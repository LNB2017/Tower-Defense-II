.thumb

	.macro blh to, reg = r3
    ldr \reg, =\to
    mov lr, \reg
    .short 0xF800
	.endm

	// Variables

	.equ gActiveUnit,			0x3004E50
	.equ gActionData,			0x203A958
	.equ Effect_Ladder_End, 	0x802FF76 + 1
	.equ Usability_Ladder_End, 	0x8028BFE + 1

	// Functions

	.equ NewItemGot, 0x8011554
		// Input:
			// r0 - ProcState
			// r1 - Unit Addr
			// r2 - Item + Durability

	.equ MakeItem, 0x8016540
		// Input:
			// r0 - ItemID
		// Output
			// r0 - Item + Durability

	.equ RemoveUnitBlankItems, 0x8017984
		// Input:
			// r0 - Unit Addr

	.equ NextRN_100, 0x8000C64
		// Output:
			// r0 - RN Rolled

	.equ NextRN_N, 0x08000C80
		// Input:
			// r0 - RN Upper Bound
		// Output:
			// r0 - RN Rolled

	.global LootBox_Effect_Ladder
	.type   LootBox_Effect_Ladder, function

	.global LootBox_Usability_Ladder
	.type	LootBox_Usability_Ladder, function

	LootBox_Effect_Ladder:

		mov r0, r6 // ProcState

		bl LootBox_Effect

		ldr r3, = #Effect_Ladder_End
		bx r3

		.pool
		.align

	LootBox_Effect:

		push {lr}
		push {r4-r7}

		mov r6, r0 // ProcState

		ldr r0, = #gActiveUnit
		ldr r4, [r0]
		mov r1, r4

		ldr r0, = #gActionData
		ldrb r0, [r0, #0x12] // Item Slot
		lsl r0, #1 // x2
		add r0, #0x1E // Items
		add r0, r4
		ldrb r5, [r0] // LootBox ItemID
		mov r1, #0
		strh r1, [r0]
		mov r0, r4
		blh RemoveUnitBlankItems

		mov r0, r5
		bl GetLootboxItem
		blh MakeItem
		mov r2, r0

		mov r0, r6
		mov r1, r4

		blh NewItemGot

		pop {r4-r7}
		pop {r0}
		bx r0

		.pool
		.align	

	GetLootboxItem:
		// Input:
			// r0 - LootBox ItemID
		// Output:
			// r0 - ItemID

		push {lr}
		push {r4-r7}

		mov r4, r0

		ldr r0, =LootBox_Type_Table_Pointer
		ldr r0, [r0]
		mov r1, r4
		lsl r1, #2 // x4
		ldr r0, [r0, r1]

		mov r5, r0

		blh NextRN_100
		mov r4, r0

		Get_LootBox_List_Loop:
		ldrb r0, [r5, #4]
		sub r4, r0
		cmp r4, #0
		ble Return_LootBox_List
		add r5, #8
		b Get_LootBox_List_Loop

		Return_LootBox_List:
		ldr r0, [r5]
		mov r4, r0

		ldr r0, [r4]
		blh NextRN_N
		add r0, #4
		ldrb r0, [r4, r0]

		pop {r4-r7}
		pop {r1}
		bx r1

		.pool
		.align

	LootBox_Usability_Ladder:

		mov r0, r4

		bl LootBox_Usability

		ldr r3, = #Usability_Ladder_End
		bx r3

		.pool
		.align

	LootBox_Usability:

		mov r0, #1
		bx lr

		.pool
		.align
