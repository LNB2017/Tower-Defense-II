.thumb
.include "_Buy_Unit_Defs.asm"

@r0 = Buy_Unit_Proc

.equ GoldX, 9
.equ GoldY, 2

push	{r4-r7,r14}
mov		r4,r0

@clear bg2
ldr		r0,=BGLayer2
mov		r1,#0
_blh	FillBgMap

@bg stuff
ldr		r0,Buy_Menu_Graphics
mov		r1,#0xC0
lsl		r1,#0x13			@6000000
_blh	Decompress
ldr		r0,=BGLayer2
ldr		r1,Buy_Menu_TSA		@uncompressed
mov		r2,#0x1				@palette <<0xC
lsl		r2,#0xC
ldr		r3,Put_Image_Together
_blr	r3
ldr		r0,Buy_Menu_Palette
mov		r1,#0x20			@palette bank
mov		r2,#0x20
_blh	CopyToPaletteBuffer

@Font stuff
_blh Font_InitDefault		@Set font stuff to default
ldr		r5,=BuyUnitTextStruct
str		r5,[r4,#0x40]
mov		r6,#0				@loop counter
ClearTilesForTextLoop:
mov		r0,r5
mov		r1,#TileNumberForClassName
_blh	Text_InitClear
add		r5,#8
add		r6,#1
cmp		r6,#MaxNumberOfEntriesAtOnce
blt		ClearTilesForTextLoop

@Initialize the tab number, which row the arrow points at, and which slot is at the top of the screen
mov		r0,#0
strh	r0,[r4,#0x2C]		@tab number (0 for unpromoted, 1 for promoted)
strh	r0,[r4,#0x2E]		@which row the arrow points at (relative to screen)
strh	r0,[r4,#0x30]		@which row is at the top of the screen
strh	r0,[r4,#0x34]		@bg0 offset for shifting when scrolling
mov		r0,r4
ldr		r3,Calc_Max_Entries
_blr	r3

@Fill in the text
mov		r0,r4
ldr		r3,Fill_In_Menu
_blr	r3

@initialize the description pane
@Draw the money and 'G' symbol
ldr		r6,=(BGLayer1 + 0x40*GoldY + 2*GoldX)
mov		r0,r6
_blh	0x80B4E88			@draws the 'G'
sub		r0,r6,#2
_blh	0x80B4ED4			@draws the money
@r5 is the most recently used font struct
@draw the stat names
mov		r6,#0
ldr		r7,StatNameTextIDList
StatNameTextStructLoop:
add		r5,#8
mov		r0,r5
mov		r1,#3
_blh	Text_InitClear
mov		r0,r5
mov		r1,#0				@x coord
mov		r2,#3				@palette id (yellow)
_blh	Text_SetParameters
ldrh	r0,[r7]				@stat name text id
_blh	GetStringFromIndex
mov		r1,r0
mov		r0,r5
_blh	Text_AppendString
mov		r0,r5
ldr		r1,=(BGLayer1 + 0x40*StatY + 2*StatX)
lsl		r2,r6,#7
add		r1,r2
_blh	Text_Draw
add		r7,#2
add		r6,#1
cmp		r6,#8
blt		StatNameTextStructLoop
@draw the labels in other column: 'Lv', 'Promotions:', 'Uses:', 'Skills:'
@Lvl
add		r5,#8
mov		r0,r5
mov		r1,#3
_blh	Text_InitClear
mov		r0,r5
mov		r1,#0
mov		r2,#3
_blh	Text_SetParameters
ldr		r0,=#0x4E7			@Lv
_blh	GetStringFromIndex
mov		r1,r0
mov		r0,r5
_blh	Text_AppendString
mov		r0,r5
ldr		r1,=(BGLayer1 + 0x40*Desc2Y + 2*Desc2X)
_blh	Text_Draw
@Promotions:
add		r5,#8
mov		r0,r5
mov		r1,#7
_blh	Text_InitClear
mov		r0,r5
mov		r1,#0
mov		r2,#3
_blh	Text_SetParameters
adr		r0,Extra_Text_IDs
ldrh	r0,[r0]
_blh	GetStringFromIndex
mov		r1,r0
mov		r0,r5
_blh	Text_AppendString
mov		r0,r5
ldr		r1,=(BGLayer1 + 0x40*(Desc2Y+2) + 2*Desc2X)
_blh	Text_Draw
@Uses:
add		r5,#8
mov		r0,r5
mov		r1,#7
_blh	Text_InitClear
mov		r0,r5
mov		r1,#0
mov		r2,#3
_blh	Text_SetParameters
adr		r0,Extra_Text_IDs
ldrh	r0,[r0,#2]
_blh	GetStringFromIndex
mov		r1,r0
mov		r0,r5
_blh	Text_AppendString
mov		r0,r5
ldr		r1,=(BGLayer1 + 0x40*(Desc2Y+8) + 2*Desc2X)
_blh	Text_Draw
@Skills:
add		r5,#8
mov		r0,r5
mov		r1,#7
_blh	Text_InitClear
mov		r0,r5
mov		r1,#0
mov		r2,#3
_blh	Text_SetParameters
adr		r0,Extra_Text_IDs
ldrh	r0,[r0,#4]
_blh	GetStringFromIndex
mov		r1,r0
mov		r0,r5
_blh	Text_AppendString
mov		r0,r5
ldr		r1,=(BGLayer1 + 0x40*(Desc2Y+12) + 2*Desc2X)
_blh	Text_Draw
add		r5,#8
str		r5,[r4,#0x44]
mov		r0,r5
mov		r1,#7
_blh	Text_InitClear
add		r5,#8
mov		r0,r5
mov		r1,#7
_blh	Text_InitClear

mov		r0,r4
ldr		r3,Draw_Description_Pane
_blr	r3

@make sure bg2 updates
mov		r0,#4
_blh	EnableBGSyncByMask
ldr		r3,=gLCDControlBuffer
ldrb	r0,[r3,#0x14]		@bg2 stuff
mov		r1,#3
bic		r0,r1
mov		r1,#1
orr		r0,r1
strb	r0,[r3,#0x14]

pop		{r4-r7}
pop		{r0}
bx		r0

.ltorg
.equ Calc_Max_Entries, Fill_In_Menu+4
.equ Put_Image_Together, Calc_Max_Entries+4
.equ Buy_Menu_Graphics, Put_Image_Together+4
.equ Buy_Menu_TSA, Buy_Menu_Graphics+4
.equ Buy_Menu_Palette, Buy_Menu_TSA+4
.equ StatNameTextIDList, Buy_Menu_Palette+4
.equ Draw_Description_Pane, StatNameTextIDList+4
@Make sure this is at the end
.equ Extra_Text_IDs, Draw_Description_Pane+4
Fill_In_Menu:
@
