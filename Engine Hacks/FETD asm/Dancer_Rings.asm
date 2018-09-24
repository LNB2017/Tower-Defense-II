.thumb

@r0=target's data ptr

push	{r14}
ldr		r1,[r0]
ldr		r1,[r1,#0x28]
ldr		r2,[r0,#4]
ldr		r2,[r2,#0x28]
orr		r1,r2
mov		r2,#0x30
tst		r1,r2
bne		WriteStatus			@if target has dance capabilities, don't refresh them
ldr		r1,[r0,#0xC]
ldr		r2,=#0xFFFFFBBD
and		r1,r2
str		r1,[r0,#0xC]
WriteStatus:
mov		r1,r5
mov		r2,#1
ldr		r3,=#0x80178F4		@SetUnitStatus
mov		r14,r3
.short	0xF800
ldr		r1,=#0x203A4D4		@gBattleStats
mov		r0,#0x80
pop		{r2}
bx		r2

.ltorg
