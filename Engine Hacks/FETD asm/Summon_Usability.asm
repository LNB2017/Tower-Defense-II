.thumb

@replaces the standard Summon command at 243D8

push	{r4-r5,r14}
ldr		r4,=#0x3004E50
ldr		r4,[r4]
ldr		r0,[r4,#0xC]
mov		r1,#0x40
tst		r0,r1
bne		RetFalse
mov		r0,r4
ldr		r1,SummonID
ldr		r3,SkillTester
mov		r14,r3
.short	0xF800
cmp		r0,#0
beq		RetFalse
mov		r0,r4
ldr		r3,=#0x8025CA4			@make list of squares we can summon in
mov		r14,r3
.short	0xF800
ldr		r3,=#0x804FD28			@GetTargetListSize
mov		r14,r3
.short	0xF800
cmp		r0,#0
beq		RetFalse
ldr		r5,PhantomCharIDList
PhantomLoop:
ldrb	r0,[r5]
cmp		r0,#0
beq		RetFalse				@if 0, then all phantoms are deployed
ldr		r3,=#0x801829C			@FindChar
mov		r14,r3
.short	0xF800
cmp		r0,#0
beq		RetTrue
add		r5,#1
b		PhantomLoop
RetTrue:
mov		r0,#1
b		GoBack
RetFalse:
mov		r0,#3
GoBack:
pop		{r4-r5}
pop		{r1}
bx		r1

.ltorg
.equ SummonID, SkillTester+4
.equ PhantomCharIDList, SummonID+4
SkillTester:
@
