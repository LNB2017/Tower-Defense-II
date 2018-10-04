.thumb

@jumped to from 183FC

@r0=char data ptr

push	{r4,r14}
mov		r4,r0
ldrb	r0,[r4,#0xB]
mov		r1,#0x80
tst		r0,r1
beq		DontGiveMoney
mov		r0,r4
ldr		r3,Get_Enemy_Worth
mov		r14,r3
.short	0xF800
ldr		r3,=#0x8024E20		@Add gold
mov		r14,r3
.short	0xF800
DontGiveMoney:
ldr		r1,[r4,#0xC]
mov		r2,#0x20
tst		r1,r2
bne		GoBack			@solely for capture purposes
mov		r1,#0
str		r1,[r4]			@zero out char data
GoBack:
pop		{r4}
pop		{r0}
bx		r0

.ltorg
Get_Enemy_Worth:
@
