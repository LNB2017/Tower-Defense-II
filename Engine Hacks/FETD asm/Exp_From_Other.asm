.thumb

.equ ParagonID, SkillTester+4

push	{r14}
mov		r0,r4
ldr		r1,ParagonID
ldr		r3,SkillTester
mov		r14,r3
.short	0xF800
mov		r1,#10		@base exp for steal, summon, etc
cmp		r0,#0
beq		StoreExp
lsl		r1,#1
StoreExp:
mov		r0,#0x6E
strb	r1,[r4,r0]
ldrb	r0,[r4,#9]
add		r0,r1
strb	r0,[r4,#9]
pop		{r0}
bx		r0

.align
SkillTester:
@
