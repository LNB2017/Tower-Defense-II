.thumb

@called from 2C668
@r4=char data ptr

.equ ParagonID, SkillTester+4

push	{r5,r14}
ldrh	r0,[r0]				@item
ldr		r3,=#0x80175DC		@get item might (staff exp)
mov		r14,r3
.short	0xF800
mov		r5,r0
mov		r0,r4
ldr		r1,ParagonID
ldr		r3,SkillTester
mov		r14,r3
.short	0xF800
cmp		r0,#0
beq		GoBack
lsl		r5,#1
GoBack:
mov		r0,r5
pop		{r5}
pop		{r1}
bx		r1

.ltorg
SkillTester:
@
