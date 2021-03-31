.thumb

	.macro blh to, reg = r3
    ldr \reg, =\to
    mov lr, \reg
    .short 0xF800
	.endm

	.equ NextRN_N, 0x08000C80
	.equ gChapterData, 0x202BCF0
	.equ CharacterTable, 0x803D64

	.global InitUnit
	.type 	InitUnit, function

	InitUnit:

		// r6 - UNIT data

		push {lr}

		ldr r0, =#0x203F100
		ldrb r1, [r5, #0xB]
		lsl r1, #3
		add r0, r1 // r0 = new unit address

		mov r1, #0x0
		str r1, [r0]
		str r1, [r0, #0x4]

		ldrb r0, [r6, #0x3]
		lsr r0, #3 // level

		bl AddUnitLevel

		strb r0, [r5, #0x8]

		mov r1, r5
		add r1, #0x10
		mov r2, r5

		pop {r0}
		mov lr, r0

		ldr r3, =#0x81C20FA+1
		bx r3

		.pool
		.align

	AddUnitLevel:

		push {lr}
		push {r4-r7}

		mov r4, r0

		ldrb r0, [r6]
		ldr r1, =CharacterTable
		mov r2, #52
		mul r0, r2
		add r0, r1

		mov r1, #0x2B // ability 4
		ldrb r0, [r0, r1]
		mov r1, #0x40
		and r0, r1
		cmp r0, #0
		beq NoBonus

		ldrb r0, [r6, #0x3]
		mov r1, #6
		and r0, r1
		lsr r0, #1
		cmp r0, #2
		bne NoBonus

		ldr r2, =gChapterData

		ldrh r0, [r2, #0x10] // current turn

		ldrb r1, [r2, #0x14]
		mov r2, #0x40 // hard mode
		and r2, r1
		cmp r2, #0
		bne HardMode

		ldr r1, =Random_Level_Word
		ldr r1, [r1]
		b Cont

		HardMode:
		ldr r1, =Random_Hard_Level_Word
		ldr r1, [r1]

		Cont:

		swi #0x6 // div
		blh NextRN_N

		NoBonus:

		add r0, r4
		bl BoundLevel

		pop {r4-r7}
		pop {r1}
		bx r1

		.pool
		.align

	BoundLevel:

		cmp r0, #20
		ble EndBounding

		mov r0, #20

		EndBounding:

		bx lr

		.pool
		.align
