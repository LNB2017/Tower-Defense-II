.thumb

	.macro blh to, reg=r3
	    ldr \reg, =\to
	    mov lr, \reg
	    .short 0xF800
	.endm

	.equ gActiveUnit, 0x3004E50
	.equ gActiveUnitPosition, 0x202BE48
	.equ MoveUnit, 0x807A015

	push {r14}
	push {r4-r7}

	ldr r0, =gActiveUnit
	ldr r0, [r0]

	ldr r4, =gActiveUnitPosition // this has our coords before moving
	ldrh r1, [r4]
	ldrh r2, [r4, #0x2]

	mov r3, #1
	neg r3, r3

	blh MoveUnit

	pop {r4-r7}
	pop {r0}
	bx r0

.ltorg
.align
