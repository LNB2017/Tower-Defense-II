.thumb

.macro _blh to, reg=r3
	ldr \reg, =\to
	mov lr, \reg
	.short 0xF800
.endm

.macro _blr reg
	mov lr, \reg
	.short 0xF800
.endm

@0x2C is tab number (0 for promoted, 1 for unpromoted)
@0x2E is current slot number
@0x30 is slot number at top of screen
@0x32 is max number of entries in this tab
@0x34 is the shift value for bg0 scrolling (actually, not using this anymore it seems)
@0x40 is text struct pointer
@0x44 is text struct pointer for the promotion options (probably don't need to keep these separate, but am doing so anyway)
@0x48 is beginning of new UNIT data (after pressing A)

.set Font_InitDefault, 0x8003C94
.set Text_InitClear, 0x8003D5C
.set SetFont, 0x8003D38
.set Font_LoadForUI, 0x80043A8
.set Text_Clear, 0x8003DC8
.set DivMod, 0x80D1684
.set Divide, 0x80D167C
.set GetPartyGoldAmount, 0x8024DE8
.set Text_SetParameters, 0x8003E68
.set Get_Class_Data, 0x8019444
.set GetStringFromIndex, 0x800A240
.set FilterSomeTextFromStandardBuffer, 0x800A3B8
.set Text_AppendString, 0x8004004
.set Text_Draw, 0x8003E70
.set EnableBGSyncByMask, 0x8001FAC
.set PlaySound, 0x80D01FC
.set GoToProcLabel, 0x8002F24
.set SetBgPostion, 0x800148C
.set UpdateHandCursor, 0x804E79C
.set FillBgMap, 0x8001220
.set Decompress, 0x8012F50
.set BgTileMap_ApplyTSA, 0x80D74A0
.set CopyToPaletteBuffer, 0x8000DB8
.set WriteDecNumber, 0x8004B88
.set DrawIcon, 0x80036BC
.set NextRN_N, 0x8000C80
.set NextRN_100, 0x8000C64
.set Find_Char_ID, 0x801829C

.set BGLayer0, 0x2022CA8
.set BGLayer1, 0x20234A8
.set BGLayer2, 0x2023CA8
.set gpKeyStatus, 0x858791C
.set gChapterData, 0x202BCF0
.set gGenericBuffer, 0x2020188
.set gLCDControlBuffer, 0x3003080

.set BuyUnitTextStruct, 0x203EF68		@used by shops; hopefully it'll work here
.set TileNumberForClassName, 0x8		@number of tiles reserved for the class name text
.set MaxNumberOfEntriesAtOnce, 0x7		@max number of units displayed on the screen at one time
.set InitialEntry_X, 0x2				@x coordinate of top-most entry
.set InitialEntry_Y, 0x5				@y coordinate of top-most entry
.set CostXOffset, 0x14					@how many pixels away the cost number is from the beginning of the map sprite
.equ StatX, 24							@x coordinate in tiles of the HP stat label
.equ StatY, 3							@^, but y coordinate
.equ Desc2X,15							@x coordinate for the column that isn't stats in the description pane
.equ Desc2Y, 3
