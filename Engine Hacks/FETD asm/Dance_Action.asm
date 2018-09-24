.thumb

@replaces 32358, ActionDance
@based on ExecFortify, 2F154

.macro _blh to, reg=r3
	ldr \reg, =\to
	mov lr, \reg
	.short 0xF800
.endm


push	{r4-r7,r14}
mov		r4,r0			@Proc
ldr		r5,=#0x203A958	@ActionData
ldrb	r0,[r5,#0xC]	@subject deployment ID
_blh	0x8019430		@GetUnit
mov		r6,r0
mov		r1,#0x1
neg		r1,r1			@slot of item being used
_blh	0x802CB24		@SetupSubjectBattleUnitForStaff
mov		r0,r6
_blh	0x8025B6C		@creates target list for dance
_blh	0x804FD28		@GetTargetListSize
mov		r7,r0
mov		r0,#0
_blh	0x804FD34		@GetTarget
ldrb	r0,[r0,#2]		@deployment ID
_blh	#0x8019430		@GetUnit
_blh	#0x802CBC8		@SetupTargetBattleUnitForStaff		@ExecFortify uses GetLeader; I'm just going to use the first target, since we're guaranteed one
mov		r6,#0			@counter
DanceLoop:
mov		r0,r6
_blh	#0x804FD34
ldrb	r0,[r0,#2]
_blh	#0x8019430
ldr		r1,[r0,#0xC]
ldr		r2,=#0xFFFFFBBD
and		r1,r2
str		r1,[r0,#0xC]
add		r6,#1
cmp		r6,r7
blt		DanceLoop

ldr		r1,=#0x203A4D4	@gBattleStats
mov		r0,#0x40
strb	r0,[r1]			@indicates dance, I guess
mov		r0,r4
_blh	#0x802CC38		@SaveInstigatorWith10ExtraExp
_blh	#0x802CA14		@BeginBattleAnimations
mov		r0,#0
pop		{r4-r7}
pop		{r1}
bx		r1

.ltorg


