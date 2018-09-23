.thumb
.include "_Buy_Unit_Defs.asm"

push	{r4-r7,r14}
mov		r4,r0
ldr		r5,=gpKeyStatus
ldr		r5,[r5]
bl		Arrow_Key_Stuff
@ldrh	r2,[r4,#0x34]		@bg shift
@mov		r0,#0				@bg id?
@mov		r1,#0				@x shift, probably
@_blh	SetBgPostion
mov		r0,#(8*InitialEntry_X-3	)
mov		r1,#(8*InitialEntry_Y)
ldrh	r2,[r4,#0x2E]		@current slot
ldrh	r3,[r4,#0x30]		@top slot
sub		r2,r2,r3
lsl		r2,#4
add		r1,r2
_blh	UpdateHandCursor

@scrolling arrows
ldrh	r0,[r4,#0x30]			@top slot
cmp		r0,#0
beq		DownScrollingArrow
mov		r2,#0xC9
lsl		r2,#6				@no idea what this is
mov		r0,#(8*(InitialEntry_X+5))
mov		r1,#(8*InitialEntry_Y-4)
ldr		r3,=#0x80B53F8
mov		r14,r3
mov		r3,#1				@arrow orientation?
.short	0xF800
DownScrollingArrow:
ldrh	r0,[r4,#0x30]			@top slot
add		r0,#MaxNumberOfEntriesAtOnce
ldrh	r1,[r4,#0x32]			@max number of entries in this tab
cmp		r0,r1
bge		Shoulder_Button_Check
mov		r2,#0xC9
lsl		r2,#6
mov		r0,#(8*(InitialEntry_X+5))
mov		r1,#(8*(InitialEntry_Y+2*MaxNumberOfEntriesAtOnce)-4)
ldr		r3,=#0x80B53F8
mov		r14,r3
mov		r3,#0				@arrow orientation?
.short	0xF800

@L and R button checks
Shoulder_Button_Check:
ldrh	r0,[r5,#0x8]
mov		r1,#3
lsl		r1,#8
tst		r0,r1
beq		CheckBButton
mov		r0,r4
ldrh	r1,[r0,#0x2C]
mov		r2,#1
eor		r1,r2				@toggles between unpromoted and promoted tabs
strh	r1,[r0,#0x2C]
mov		r1,#0
strh	r1,[r0,#0x2E]		@current slot
strh	r1,[r0,#0x30]		@# of top slot
ldr		r3,Calc_Max_Entries
_blr	r3
mov		r0,r4
ldr		r3,Fill_In_Menu
_blr	r3
mov		r0,r4
ldr		r3,Draw_Description_Pane
_blr	r3
ldr		r0,=gChapterData
add		r0,#0x41
ldrb	r0,[r0]
lsl		r0,#0x1E
cmp		r0,#0
blt		Label1
mov		r0,#0xC8			@page changing noise
_blh	PlaySound
Label1:
b		GoBack

CheckBButton:
@B button
mov		r1,#2
tst		r0,r1
beq		CheckAButton
ldr		r0,=gChapterData
add		r0,#0x41
ldrb	r0,[r0]
lsl		r0,#0x1E
cmp		r0,#0
blt		GoToBLabel
mov		r0,#0x6B			@menu closing noise
_blh	PlaySound
GoToBLabel:
mov		r0,r4
mov		r1,#0xB
_blh	GoToProcLabel
b		GoBack

CheckAButton:
@A button
mov		r1,#1
tst		r0,r1
beq		GoBack
mov		r0,r4
mov		r1,#0xA
_blh	GoToProcLabel

GoBack:
pop		{r4-r7}
pop		{r0}
bx		r0

.ltorg


Arrow_Key_Stuff:
@r0 = Buy_Unit proc
push	{r4-r7,r14}
mov		r4,r0
ldrh	r0,[r4,#0x2E]		@current slot
ldrh	r1,[r4,#0x32]		@max
mov		r2,#0
_blh	#0x80B5498			@returns new slot number (same if there was no arrow key press or if key press was out of bounds)
ldrh	r5,[r4,#0x2E]		@current slot
cmp		r0,r5
beq		UpdateBGPosition	@if new slot = current slot, don't bother
strh	r0,[r4,#0x2E]		@new slot
mov		r0,r4
ldr		r3,Draw_Description_Pane
_blr	r3					@updates the side pane for the new unit
@now we figure out if we need to scroll and redraw the unit names and stuff
ldrh	r2,[r4,#0x32]		@max
cmp		r2,#MaxNumberOfEntriesAtOnce
blt		UpdateBGPosition	@if # of entries to show is less than can be displayed, don't redraw
@r5 has previous slot
ldrh	r0,[r4,#0x2E]		@current slot
ldrh	r2,[r4,#0x30]		@slot number at top of screen
cmp		r0,r5
bgt		ScrollDown
@ScrollUp
cmp		r2,#0
beq		UpdateBGPosition	@if top slot is 0, we can't scroll up any further
cmp		r0,r2
bgt		UpdateBGPosition	@if new slot != top slot, no need to scroll
sub		r2,#1
strh	r2,[r4,#0x30]		@new top slot
b		RedrawMenu
ScrollDown:
add		r2,#MaxNumberOfEntriesAtOnce
ldrh	r3,[r4,#0x32]		@max
cmp		r2,r3
beq		UpdateBGPosition	@if at the bottom, we can't scroll any further
sub		r2,#1				@may be off by 1 here, not sure
cmp		r0,r2
blt		UpdateBGPosition
ldrh	r2,[r4,#0x30]		@slot number at top
add		r2,#1
strh	r2,[r4,#0x30]
RedrawMenu:
mov		r0,r4
ldr		r3,Fill_In_Menu
_blr	r3
UpdateBGPosition:
@ldrh	r0,[r4,#0x34]		@current shift
@ldrh	r1,[r4,#0x30]		@new top slot
@mov		r2,#0x10
@mul		r1,r2
@mov		r2,#4
@_blh	0x80B557C
@strh	r0,[r4,#0x34]
pop		{r4-r7}
pop		{r0}
bx		r0

.ltorg
.equ Fill_In_Menu, Draw_Description_Pane+4
.equ Calc_Max_Entries, Fill_In_Menu+4
Draw_Description_Pane:
@
