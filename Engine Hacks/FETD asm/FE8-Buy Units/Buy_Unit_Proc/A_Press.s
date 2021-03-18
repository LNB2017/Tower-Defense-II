.thumb
.include "_Buy_Unit_Defs.asm"

.global A_Press
.type A_Press, function

A_Press:

	push	{r4-r7,r14}
	mov		r4,r0
	ldrh	r1,[r4,#0x2E]		@current slot
	ldr		r3, =Get_Entry_Pointer_Pointer
	ldr r3, [r3]
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

	@making the unit
	mov		r6,r4
	add		r6,#0x48
	GetFreeCharacterLoop:
	mov		r0,#100					@number of character entries, hopefully
	_blh	NextRN_N
	add		r0,#1
	mov		r7,r0
	_blh	Find_Char_ID
	cmp		r0,#0
	bne		GetFreeCharacterLoop
	strb	r7,[r6]
	ldrb	r0,[r5]
	strb	r0,[r6,#0x1]			@class id

	_blh	Get_Class_Data
	mov r1, #0x29
	ldrb r0, [r0, r1] // ability2
	mov r1, #0x1 // ispromoted
	and r1, r0
	cmp r1, #0x1
	beq NotElite // promoted units arent elite

	// roll for elites
	_blh NextRN_100
	ldr r1, =Elite_Chance_Pointer
	ldr r1, [r1]
	ldr r1, [r1]
	cmp r0, r1
	bge NotElite
	mov r7, #1
	b CntElite
	NotElite:
	mov r7, #0
	CntElite:

	mov		r0,r4
	mov r1, r7
	ldr		r3, =Get_Unit_Level_Pointer
	ldr r3, [r3]
	_blr	r3

	cmp r7, #1
	bne NoLevelBonus
	ldr r1, =Elite_Bonus_Pointer
	ldr r1, [r1]
	ldr r1, [r1]
	add r0, r1
	cmp r0, #20
	ble NoLevelBonus
	mov r0, #20
	NoLevelBonus:

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
	//ldrb	r0,[r6,#1]
	//cmp		r0,#9
	//beq		InventoryDone			@knights dont get an inventory
	mov		r0,r6
	mov r1, r7
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
	b NoSound

	GoBack:
	ldr		r1,=gChapterData
	add		r1,#0x41
	ldrb	r1,[r1]
	lsl		r1,#0x1E
	cmp		r1,#0
	blt		NoSound
	cmp r7, #1
	bne NoEliteSound
	ldr r0, = #0x2CD @ level up ping noise
	b PlayTheSound
	NoEliteSound:
	mov		r0,#0x76			@stat ping noise
	PlayTheSound:
	_blh	PlaySound

	NoSound:

	pop		{r4-r7}
	pop		{r0}
	bx		r0

	bx_r1:
	bx		r1

.ltorg
.align

CreateInventory:

	@r0=UNIT entry, so far
	@r1=bool true if elite

	push	{r4-r7,r14}
	mov		r4,r0
	ldrb	r0,[r4,#1]		@class id
	cmp r1, #1
	bne NotEliteInv
	add r0, #127
	NotEliteInv:

	// check for our random inventory nonsense
	ldr r1, =Inventory_Table_Pointer
	ldr r1, [r1]
	mov r2, #16 // entry length
	mul r0, r2
	add r1, r0
	mov r5, r1
	ldr r0, [r5]
	cmp r0, #0
	beq OldCreateInventory // if no entry just use the old method

	mov		r6,#0xC

	// here we go

	// r4 @ address of UNIT
	// r5 @ address of inventory table
	// r6 @ position of items to store

	RandomItemLoop:

	ldr r0, [r5]
	cmp r0, #0
	beq FinishedInventory
	mov r0, r5
	ldr r0, [r5]
	_blh GetRandomItem
	add r5, #4 // get next pointer from table
	cmp r0, #0
	beq RandomItemLoop
	// valid item in r0
	strb r0, [r4, r6]
	add r6, #1
	b RandomItemLoop

	OldCreateInventory:

	ldrb	r0,[r4,#1]		@class id
	_blh	Get_Class_Data
	mov		r5,r0
	mov		r6,#0xC			@position of items to store
	mov		r7,#0
	mov		r0,#44			@beginning of weapon ranks in class data
	add		r0,r5
	adr		r2, BasicWeaponList	@organized by weapon type
	ldr		r1,[r5,#0x28]	@class abilities
	mov		r3,#1
	lsl		r3,#8
	tst		r1,r3
	beq		GetWeaponRankLoop
	add		r2,#8			@promoted weapon list
	GetWeaponRankLoop:
	ldrb	r1,[r0,r7]
	cmp		r1,#0
	beq		NextWRank
	ldrb	r1,[r2,r7]		@weapon corresponding to rank
	strb	r1,[r4,r6]		@store that in inventory place
	add		r6,#1
	cmp		r6,#0xF
	beq		GetItems		@only gonna do 3 weapons, max (shouldnt be an issue)
	NextWRank:
	add		r7,#1
	cmp		r7,#8
	blt		GetWeaponRankLoop

	GetItems:
	_blh	NextRN_100
	ldr		r1, =Random_Items_Table_Pointer
	ldr r1, [r1]
	ldr		r3, =Choose_Item_From_List_Pointer
	ldr r3, [r3]
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
	ldr		r1, =Random_Rings_Table_Pointer
	ldr r1, [r1]
	ldr		r3, =Choose_Item_From_List_Pointer
	ldr r3, [r3]
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
	.byte 0x01, 0x14, 0x1F, 0x2D, 0x4B, 0x38, 0x3F, 0x45		@iron sword, iron lance, iron axe, iron bow, heal, fire, lightning, flux
	.byte 0x03, 0x16, 0x20, 0x2E, 0x4C, 0x3A, 0x40, 0x41		@steel sword, steel lance, steel axe, steel bow, mend, elfire, shine, machin shin

.ltorg
.align

GetRandomItem:
	// r0 - random item list
	push {r14}
	push {r4-r7}
	mov r5, r0
	_blh	NextRN_100
	mov r4, r0

	GetRandomItemLoop:
	ldrb r0, [r5, #1]
	sub r4, r0
	cmp r4, #0
	ble ReturnRandomItem
	add r5, #2
	b GetRandomItemLoop

	ReturnRandomItem:
	ldrb r0, [r5]
	pop {r4-r7}
	pop {r1}
	bx r1

.ltorg
.align
