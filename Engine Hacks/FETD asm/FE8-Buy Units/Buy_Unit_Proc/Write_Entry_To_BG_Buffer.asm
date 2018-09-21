.thumb
.include "_Buy_Unit_Defs.asm"

@r0=Buy_Unit proc, r1=text struct, r2=entry slot number, r3=background offset to write to

push	{r4-r7,r14}
add		sp,#-0x4
mov		r7,r0
mov		r4,r1
mov		r5,r3
mov		r1,r2
ldr		r3,Get_Entry_Pointer
_blr	r3
cmp		r0,#0
beq		GoBack		@if there's no entry to display, don't write anything
mov		r6,r0
mov		r0,#0
str		r0,[sp]		@palette index, initialized to white

@check if we can afford the unit
_blh	GetPartyGoldAmount
ldrh	r1,[r6,#0x2]
cmp		r0,r1
bge		CheckUsability
mov		r0,#1
str		r0,[sp]		@palette index now grey

CheckUsability:
ldr		r1,[r6,#0x4]
cmp		r1,#0
beq		WriteEntry
mov		r0,r7
bl		bx_r1
cmp		r0,#0
bne		WriteEntry
mov		r0,#2
str		r0,[sp]		@palette now blue (will be changed to red down the line)

WriteEntry:
mov		r0,r4		@text entry
mov		r1,#2		@x coord
ldr		r2,[sp]		@palette id
_blh	Text_SetParameters
ldrb	r0,[r6]
_blh	Get_Class_Data
ldrh	r0,[r0]		@name text id
_blh	GetStringFromIndex
_blh	FilterSomeTextFromStandardBuffer		@not sure why I need this, but the shop puts it
mov		r1,r0
mov		r0,r4
_blh	Text_AppendString
add		r1,r5,#0	@place to write
mov		r0,r4
_blh 	Text_Draw
mov		r0,r5
add		r0,#CostXOffset
ldr		r1,[sp]		@palette
ldrh	r2,[r6,#0x2]	@cost
_blh	WriteDecNumber

GoBack:
add		sp,#0x4
pop		{r4-r7}
pop		{r0}
bx		r0

bx_r1:
bx		r1

.ltorg
Get_Entry_Pointer:
@
