.thumb

@2C368 gets base exp
@2C450 gets kill exp
@2C4F0 is hardcoded values (gorgon egg, demon king?, phantom)

@jumped to from 2C578
@r4=attacker, r5=defender

.equ Chip_Base, 21
.equ Kill_Base, 20
.equ Boss_Bonus, 40		@also assassin bonus
.equ Thief_Bonus, 20	@thief/rogue

mov		r0,r5
ldr		r3,=#0x802C344		@gets level (+20 if promoted)
mov		r14,r3
.short	0xF800
str		r0,[sp]
mov		r0,r4
ldr		r3,=#0x802C344
mov		r14,r3
.short	0xF800
ldr		r1,[sp]
sub		r0,r1,r0
add		r0,#Chip_Base
ldrb	r3,[r5,#0x13]
cmp		r3,#0
bne		GoBack				@chip only
add		r0,#Kill_Base
ldr		r1,[r5]
ldr		r1,[r1,#0x28]
ldr		r2,[r5,#4]
ldr		r2,[r2,#0x28]
orr		r1,r2
ldr		r2,=#0x80008000		@boss + assassin flags
tst		r1,r2
beq		ThiefBonus
add		r0,#Boss_Bonus
ThiefBonus:
ldr		r3,[r5,#4]
ldrb	r3,[r3,#4]
cmp		r3,#0xD				@thief class id
beq		AddThiefBonus
cmp		r3,#0x33			@rogue class id
bne		GoBack
AddThiefBonus:
add		r0,#Thief_Bonus
GoBack:
cmp		r0,#100
ble		Label1
mov		r0,#100
Label1:
cmp		r0,#1
bge		Label2
mov		r0,#1
Label2:
add		sp,#4
pop		{r4-r5}
pop		{r1}
bx		r1
