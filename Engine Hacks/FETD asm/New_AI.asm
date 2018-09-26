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
bl		GetItemWithGreatestRange
cmp		r0,#0
beq		AttackEverything
mov		r2,r0
mov		r0,r7
mov		r1,#0xFF					@movement
_blh	#0x803D8D4					@fills in movement and range maps
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



GetItemWithGreatestRange:

push	{r4-r7,r14}
mov		r4,r0
mov		r5,#0x1E	@counter
mov		r6,#0		@current max range
mov		r7,#0		@item id with max range
InventoryLoop:
ldrh	r1,[r4,r5]
cmp		r1,#0
beq		RetItem
mov		r0,r4
_blh	#0x8016574	@CanUnitWieldWeapon
cmp		r0,#0
beq		NextItem
ldrh	r0,[r4,r5]
_blh	#0x8017684
cmp		r0,r6
ble		NextItem
mov		r6,r0
ldrh	r7,[r4,r5]
NextItem:
add		r5,#2
cmp		r5,#0x26
ble		InventoryLoop
RetItem:
mov		r0,r7
pop		{r4-r7}
pop		{r1}
bx		r1

.ltorg
Can_Unit_Steal:
@
