.thumb
.include "_Buy_Unit_Defs.asm"

@r0 = Buy_Unit proc
@+2C is tab number, +2E is row being pointed to, +30 is row at top of screen (for scrolling)
@+40 is pointer to beginning of text structs

push	{r4-r7,r14}
mov		r7,r8
push	{r7}
mov		r4,r0

@clear bg0
ldr		r0,=BGLayer0
mov		r1,#0
_blh	FillBgMap

@initialize font and clear text structs...or something
mov		r0,#0
_blh	SetFont
_blh	Font_LoadForUI
ldr		r5,[r4,#0x40]		@beginning of text structs
ldrh	r6,[r4,#0x30]		@row at top of screen
add		r7,r6,#MaxNumberOfEntriesAtOnce
ClearTextStructsLoop:
mov		r0,r6
mov		r1,#MaxNumberOfEntriesAtOnce
_blh	DivMod
lsl		r0,#3
add		r0,r5
_blh	Text_Clear
add		r6,#1
cmp		r6,r7
ble		ClearTextStructsLoop

@write stuff
ldr		r5,[r4,#0x40]
ldrh	r6,[r4,#0x30]		@row at top of screen
add		r7,r6,#MaxNumberOfEntriesAtOnce
mov		r8,r7
ldr		r7,=(BGLayer0 + 0x40*InitialEntry_Y + 2*InitialEntry_X)
WriteTextLoop:
mov		r0,r4
mov		r1,r5
mov		r2,r6
ldr		r3,Write_Entry_To_BG_Buffer
mov		r14,r3
mov		r3,r7
.short	0xF800
add		r5,#8
add		r6,#1
add		r7,#0x80
cmp		r6,r8
blt		WriteTextLoop

mov		r0,#1
_blh	EnableBGSyncByMask

pop		{r7}
mov		r8,r7
pop		{r4-r7}
pop		{r0}
bx		r0

.ltorg
Write_Entry_To_BG_Buffer:
@
