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
mov		r0,#0x15				@char ID
strb	r0,[r6]
ldrb	r0,[r5]
strb	r0,[r6,#0x1]			@class id
mov		r0,r4
ldr		r3,Get_Unit_Level
_blr	r3
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
str		r0,[r6,#0xC]			@inventory
str		r0,[r6,#0x10]			@AI
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

.ltorg
.equ Get_Unit_Level, Get_Entry_Pointer+4
Get_Entry_Pointer:
@

