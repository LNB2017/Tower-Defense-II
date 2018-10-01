.thumb
.include "_Buy_Unit_Defs.asm"

push	{r4-r7,r14}
mov		r4,r0
ldrh	r1,[r4,#0x2E]		@current slot
ldr		r3,Get_Entry_Pointer
_blr	r3
mov		r5,r0
ldr		r1,[r5,#4]			@usability routine, if any
cmp		r1,#0
beq		CheckMoney
mov		r0,r4
bl		bx_r1
cmp		r0,#0
beq		BadAPress
CheckMoney:
_blh	GetPartyGoldAmount
ldrh	r1,[r5,#0x2]		@unit price
cmp		r0,r1
blt		BadAPress
sub		r0,r0,r1
ldr		r1,=gChapterData
str		r0,[r1,#0x8]		@remove gold
add		r1,#0x41
ldrb	r1,[r1]
lsl		r1,#0x1E
cmp		r1,#0
blt		NoChaChing
mov		r0,#0xB9			@Cha ching noise
_blh	PlaySound
NoChaChing:

@making the unit
mov		r6,r4
add		r6,#0x48
GetFreeCharacterLoop:
mov		r0,#100					@number of character entries, hopefully
_blh	NextRN_N
mov		r7,r0
_blh	Find_Char_ID
cmp		r0,#0
bne		GetFreeCharacterLoop
strb	r7,[r6]
ldrb	r0,[r5]
strb	r0,[r6,#0x1]			@class id
mov		r0,r4
ldr		r3,Get_Unit_Level
_blr	r3
ldr		r1,[r5,#0x28]
mov		r2,#1
lsl		r2,#8
tst		r1,r2
beq		StoreLevel
lsr		r0,#1					@promoted units are level/2
StoreLevel:
lsl		r0,#3
add		r0,#1					@autolevelling flag
strb	r0,[r6,#0x3]			@Level(level, player, on)
ldr		r0,=0x202BCB0
ldrh	r1,[r0,#0x14]			@x
ldrh	r0,[r0,#0x16]			@y
lsl		r0,#6
orr		r0,r1
strh	r0,[r6,#0x4]			@x, y, flags
mov		r0,#0
strb	r0,[r6,#0x2]			@leader
strh	r0,[r6,#0x6]			@padding + # of redas
str		r0,[r6,#0x8]			@pointer to REDAs
str		r0,[r6,#0xC]			@inventory initialization
str		r0,[r6,#0x10]			@AI
ldrb	r0,[r6,#1]
cmp		r0,#9
beq		InventoryDone			@knights don't get an inventory
mov		r0,r6
bl		CreateInventory
InventoryDone:
mov		r0,r6
_blh	#0x8017AC4				@makes unit
b		GoBack

BadAPress:
ldr		r1,=gChapterData
add		r1,#0x41
ldrb	r1,[r1]
lsl		r1,#0x1E
cmp		r1,#0
blt		NoErrorNoise
mov		r0,#0x6C			@error noise
_blh	PlaySound
NoErrorNoise:
mov		r1,#0
mov		r0,r4
_blh	GoToProcLabel

GoBack:
pop		{r4-r7}
pop		{r0}
bx		r0

bx_r1:
bx		r1



CreateInventory:
@r0=UNIT entry, so far
push	{r4-r7,r14}
mov		r4,r0
ldrb	r0,[r4,#1]		@class id
_blh	Get_Class_Data
mov		r5,r0
mov		r6,#0xC			@position of items to store
mov		r7,#0
mov		r0,#44			@beginning of weapon ranks in class data
add		r0,r5
adr		r2,BasicWeaponList	@organized by weapon type
GetWeaponRankLoop:
ldrb	r1,[r0,r7]
cmp		r1,#0
beq		NextWRank
ldrb	r1,[r2,r7]		@weapon corresponding to rank
strb	r1,[r4,r6]		@store that in inventory place
add		r6,#1
cmp		r6,#0xF
beq		GetItems		@only gonna do 3 weapons, max (shouldn't be an issue)
NextWRank:
add		r7,#1
cmp		r7,#8
blt		GetWeaponRankLoop

GetItems:
_blh	NextRN_100
ldr		r1,RandomItemsTable
ldr		r3,ChooseItemFromList
mov		r14,r3
.short	0xF800
cmp		r0,#0
beq		DancerRingCheck
strb	r0,[r4,r6]
add		r6,#1

DancerRingCheck:
cmp		r6,#0x10
beq		FinishedInventory
ldr		r0,[r5,#0x28]		@class abilities
mov		r1,#0x30
tst		r0,r1
beq		FinishedInventory
_blh	NextRN_100
ldr		r1,RandomRingsTable
ldr		r3,ChooseItemFromList
mov		r14,r3
.short	0xF800
cmp		r0,#0
beq		FinishedInventory
strb	r0,[r4,r6]

FinishedInventory:
pop		{r4-r7}
pop		{r0}
bx		r0

.align
BasicWeaponList:
.byte 0x01, 0x14, 0x1F, 0x2D, 0x4E, 0x38, 0x3F, 0x45		@iron sword, iron lance, iron axe, iron bow, physic, fire, lightning, flux

.ltorg
.equ Get_Unit_Level, Get_Entry_Pointer+4
.equ RandomItemsTable, Get_Unit_Level+4
.equ RandomRingsTable, RandomItemsTable+4
.equ ChooseItemFromList, RandomRingsTable+4
Get_Entry_Pointer:
@

