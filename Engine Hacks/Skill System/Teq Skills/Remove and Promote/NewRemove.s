.thumb

	.global RemoveYesNo
	.type RemoveYesNo, function

	.macro blh to, reg=r3
	ldr \reg, =\to
	mov lr, \reg
	.short 0xF800
	.endm

	.equ NewMenu_BG0BG1, 0x804EC98

	RemoveYesNo:

	push {lr}
	push {r4}

	mov r4, r0
	mov r2, r1

	ldrh r0, [r2, #0x2A]
	add r0, #3
	lsl r0, #0x18
	lsr r0, #0x18
	ldr r1, =#0xFFFFFF00
	and r3, r1
	orr r3, r0
	ldrh r0, [r2, #0x2C]
	lsl r0, #0x18
	lsr r0, #0x10
	ldr r1, =#0xFFFF00FF
	and r3, r1
	orr r3, r0
	ldr r0, =#0xFF00FFFF
	and r3, r0
	mov r0, #0xA0
	lsl r0, #0xB
	orr r3, r0
	ldr r0, =#0x00FFFFFF
	and r3, r0
	ldr r0, =RemoveYesNoMenuPointer
	ldr r0, [r0]
	mov r1, r3
	mov r2, r4
	blh NewMenu_BG0BG1
	add r0, #0x61
	mov r1, #0x1
	strb r1, [r0]
	mov r0, #0x84
	
	pop {r4}
	pop {r1}
	bx r1

	.ltorg
	.align
