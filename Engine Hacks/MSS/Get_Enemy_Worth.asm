.thumb

@r0=char data ptr

push	{r4,r5,r14}
mov		r4,r0
adr		r5,ValueOptions
ldr		r0,[r4]
ldr		r0,[r0,#0x28]
ldr		r1,[r4,#4]
ldr		r1,[r1,#0x28]
orr		r0,r1
mov		r3,r0
mov		r1,#1
lsl		r1,#8
tst		r0,r1
bne		IsPromoted
ldrh	r0,[r5]			@unpromoted base value
ldrb	r1,[r4,#8]		@level
ldrh	r2,[r5,#2]		@unpromoted level multipler
mul		r1,r2
add		r0,r1
b		AddBonuses
IsPromoted:
ldr		r0,[r5,#4]		@promoted base value
ldrb	r1,[r4,#8]		@level
ldrh	r2,[r5,#6]		@promoted level multiplier
mul		r1,r2
add		r0,r1
AddBonuses:
ldr		r1,[r4,#4]
ldrb	r1,[r1,#4]
cmp		r1,#0xD			@thief
bne		CheckRogue
ldrh	r2,[r5,#8]		@thief bonus
add		r0,r2
CheckRogue:
cmp		r1,#0x33		@rogue
bne		CheckBoss
ldrh	r2,[r5,#0xA]	@rogue bonus
add		r0,r2
CheckBoss:
mov		r2,#0x80
lsl		r2,#8
tst		r2,r3
beq		CheckAssassin
ldrh	r2,[r5,#0xC]
add		r0,r2
CheckAssassin:
mov		r2,#0x80
lsl		r2,#0x18
tst		r2,r3
beq		GoBack
ldrh	r2,[r5,#0xE]
add		r0,r2
GoBack:
pop		{r4-r5}
pop		{r1}
bx		r1

.align
ValueOptions:
@
