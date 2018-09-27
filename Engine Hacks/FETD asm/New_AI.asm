.thumb

@replaces the function at 3C974
@r0=pointer of current AI counter

.macro _blh to, reg=r3
	ldr \reg, =\to
	mov lr, \reg
	.short 0xF800
.endm


push	{r4-r7,r14}
add		sp,#-4
mov		r4,r0
ldr		r5,=#0x203AA94
ldr		r6,=#0x30017D0				@gpAiScriptCurrent
ldr		r7,=#0x3004E50				@current char ptr
ldr		r7,[r7]

@try to execute staff ai
ldr		r0,=#0x803C819				@checks if 2 units are on the same side
_blh	0x803FA40					@AiTryDoStaff
cmp		r0,#0
bne		Done

@steal AI here
mov		r0,r7
ldr		r3,Can_Unit_Steal
mov		r14,r3
.short	0xF800
cmp		r0,#0
beq		TryToAttackTarget
mov		r0,r7
_blh	#0x80179D8					@GetItemCount
cmp		r0,#4
bgt		TryToAttackTarget
mov		r0,r7
_blh	#0x801A38C					@FillMovementMapForUnit
_blh	#0x801A8E4					@DoSomeMovementMapFiltering
_blh	#0x803DB60					@AiTryDoSteal
cmp		r0,#1
beq		Done

@Try to attack target
TryToAttackTarget:
ldr		r0,=#0x803C8F5				@checks if target = char id in the ai table
_blh	#0x803D450					@AiTryDoOffensiveAction
ldrb	r0,[r5,#0xA]				@decision byte?
cmp		r0,#0
bne		Done

@try to move toward target
ldr		r0,[r6]
ldr		r0,[r0,#4]					@char id of target
_blh	#0x801829C					@GetUnitByCharId
cmp		r0,#0
beq		AttackEverything			@shouldn't happen, since target dying = game over
str		r0,[sp]
mov		r0,r7
mov		r1,#0xFF					@movement
bl		FillInRangeForMoveableSpaces
ldr		r0,[sp]
ldr		r3,=#0x202E4E4
ldr		r3,[r3]
ldrb	r1,[r0,#0x11]
lsl		r2,r1,#2
ldr		r3,[r3,r2]
ldrb	r2,[r0,#0x10]
ldrb	r3,[r3,r2]
cmp		r3,#0
beq		AttackEverything			@I think this should mean the way to the target is blocked
ldrb	r0,[r0,#0x10]
mov		r2,#0
str		r2,[sp]
mov		r2,#0
ldr		r3,=#0x803BA08				@SetAiActionMoveBest
mov		r14,r3
mov		r3,#0xFF
.short	0xF800
ldrb	r0,[r5,#0xA]
cmp		r0,#0
bne		Done

@attack anyone/move towards anyone
AttackEverything:
ldr		r0,=#0x803C819
_blh	#0x803D450
ldrb	r0,[r5,#0xA]
cmp		r0,#0
bne		Done

@Nothing happened, so go with AI2 stuff?
ldr		r0,=#0x203AA04				@gAiData
add		r0,#0x86
mov		r1,#1
strb	r1,[r0]
mov		r0,#0
ldr		r0,=#0x30017C8				@gAiScriptEndedFlag
mov		r1,#0
strb	r1,[r0]

Done:
ldrb	r0,[r4]
add		r0,#1
strb	r0,[r4]
add		sp,#4
pop		{r4-r7}
pop		{r0}
bx		r0

.ltorg


FillInRangeForMoveableSpaces:
@Based on 0x803D8D4
@r0=char data ptr, r1=range
@fills in movement map, fills in range map based on squares that can be moved to (checks for units) for all weapons

push	{r4-r7,r14}
mov		r4,r8
mov		r5,r9
mov		r6,r10
mov		r7,r11
push	{r4-r7}
mov		r8,r0
mov		r9,r1
mov		r1,#1
neg		r1,r1
_blh	#0x80171E8			@GetUnitRangeMask
mov		r10,r0
cmp		r0,#0
beq		EndFillRange
mov		r0,r8
_blh	#0x8018D4C			@GetUnitMovCostTable
_blh	#0x801A4CC			@StoreMovCostTable
ldr		r0,=#0x202E4E0		@movement map
ldr		r0,[r0]
_blh	#0x801B998			@SetSubjectMap
mov		r3,r8
ldrb	r0,[r3,#0x10]
ldrb	r1,[r3,#0x11]
mov		r2,r9
ldrb	r3,[r3,#0xB]
_blh	#0x801A4EC, r4		@FillMovementMap
mov		r0,r8
mov		r1,#1
neg		r1,r1
ldr		r0,=#0x202E4E4		@range map
ldr		r0,[r0]
mov		r1,#0
_blh	#0x80197E4			@ClearMapWith
ldr		r0,=#0x202E4D4		@map size
mov		r1,#2
ldsh	r1,[r0,r1]
sub		r5,r1,#1			@y
mov		r1,#0
ldsh	r1,[r0,r1]
sub		r4,r1,#1			@max x
mov		r11,r4

Y_Loop:
mov		r4,r11				@current x
X_Loop:
ldr		r0,=#0x202E4E0
ldr		r0,[r0]
lsl		r3,r5,#2
ldr		r0,[r0,r3]
ldrb	r0,[r0,r4]
cmp		r0,#0xFF
beq		NextTile
ldr		r0,=#0x202E4D8		@unit map
ldr		r0,[r0]
ldr		r0,[r0,r3]
ldrb	r0,[r0,r4]
cmp		r0,#0
beq		FillRange
mov		r1,#0x80
tst		r0,r1
beq		NextTile			@if ally/npc, consider this occupied
FillRange:
mov		r7,r10
lsl		r7,#16				@range bitfield is a short, I think
mov		r6,#16
Max_Loop:
cmp		r7,#0
blt		FillInRangeMax
sub		r6,#1
lsl		r7,#1
b		Max_Loop
FillInRangeMax:
mov		r0,r4
mov		r1,r5
mov		r2,r6
ldr		r3,=#0x801AABC		@MapAddInRange
mov		r14,r3
mov		r3,#1
.short	0xF800
Min_Loop:
cmp		r7,#0
bge		FillInRangeMin
sub		r6,#1
lsl		r7,#1
b		Min_Loop
FillInRangeMin:
mov		r0,r4
mov		r1,r5
mov		r2,r6
ldr		r3,=#0x801AABC		@MapAddInRange
mov		r14,r3
mov		r3,#1
neg		r3,r3
.short	0xF800
cmp		r7,#0
bne		Max_Loop

NextTile:
sub		r4,#1
cmp		r4,#0
bge		X_Loop
sub		r5,#1
cmp		r5,#0
bge		Y_Loop

EndFillRange:
pop		{r4-r7}
mov		r8,r4
mov		r9,r5
mov		r10,r6
mov		r11,r7
pop		{r4-r7}
pop		{r0}
bx		r0

.ltorg
Can_Unit_Steal:
@
