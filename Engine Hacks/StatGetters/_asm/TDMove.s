.thumb

.macro blh to, reg=r3
	ldr \reg, =\to
	mov lr, \reg
	.short 0xF800
.endm

.equ PassableID, SkillTester+4

push	{r4-r5,r14}
mov		r4,r0			@stat
mov		r5,r1			@char data ptr
ldrb	r0,[r5,#0xB]
mov		r1,#0xC0
tst		r0,r1
bne		GoBack
mov		r1,#0x41
ldrb	r1,[r5,r1]
mov		r2,#0x20
tst		r1,r2
bne		Stuck
mov		r4,#60			@I think 63 is the max, even with expanding the coordinate buffer, but that should be plenty
b		GoBack

Stuck:
mov		r0,r5
ldr		r1,PassableID
ldr		r3,SkillTester
mov		r14,r3
.short	0xF800
cmp		r0,#0
bne		GoBack			@don't negate mov for units with Passable
mov		r4,#0
GoBack:
mov		r0,r4
mov		r1,r5
pop		{r4-r5,pc}

.align
SkillTester:
@
