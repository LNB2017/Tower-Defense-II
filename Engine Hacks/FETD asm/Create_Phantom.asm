.thumb

@based on the mess that is 7AD1C

push	{r4-r7,r14}
ldr		r4,=#0x3001C38			@where we make the UNIT struct
ldr		r5,PhantomCharIDList
PhantomCharLoop:
ldrb	r0,[r5]
cmp		r0,#0
beq		GoBack					@in case we somehow got here
ldr		r3,=#0x801829C			@FindChar
mov		r14,r3
.short	0xF800
cmp		r0,#0
beq		FoundChar
add		r5,#1
b		PhantomCharLoop
FoundChar:
mov		r0,#0
str		r0,[r4]
str		r0,[r4,#4]
str		r0,[r4,#8]
str		r0,[r4,#12]
str		r0,[r4,#16]				@clear block
ldrb	r0,[r5]
strb	r0,[r4]
mov		r0,#0x51				@phantom class id
strb	r0,[r4,#1]
ldr		r0,=#0x3004E50
ldr		r0,[r0]
ldrb	r6,[r0,#8]				@level
lsl		r1,r6,#3
ldrb	r2,[r0,#0xB]
mov		r3,#0xC0
and		r2,r3
lsl		r2,#1
orr		r1,r2
add		r1,#1
strb	r1,[r4,#3]				@level + allegiance + autolevelling flag
ldr		r0,=#0x203A958
ldrb	r1,[r0,#0x13]			@target x
mov		r3,#0x3F
and		r1,r3
ldrb	r0,[r0,#0x14]			@target y
and		r0,r3
lsl		r0,#6
orr		r0,r1
strh	r0,[r4,#4]				@coordinates + flags
@inventory
mov		r0,#13
mul		r6,r0
lsr		r6,#6					@13/64 = divide by 5, approximately
mov		r0,#4
ldr		r3,=#0x8000C80			@NextRN_N
mov		r14,r3
.short	0xF800
lsl		r0,#2
ldr		r7,PhantomItemPointer
ldr		r7,[r7,r0]				@picks item type
lsl		r6,#2
ldr		r7,[r7,r6]				@picks level range
ldr		r3,=#0x8000C64			@NextRN_100
mov		r14,r3
.short	0xF800
mov		r1,r7
ldr		r3,ChooseItemFromList
mov		r14,r3
.short	0xF800
strb	r0,[r4,#0xC]			@item
mov		r0,#0x20				@GuardTileAI, so that they only move 5 squares
strb	r0,[r4,#0x13]
mov		r0,r4
ldr		r3,=#0x8017AC4			@LoadUnit
mov		r14,r3
.short	0xF800
GoBack:
pop		{r4-r7}
pop		{r0}
bx		r0

.ltorg
.equ PhantomItemPointer, PhantomCharIDList+4
.equ ChooseItemFromList, PhantomItemPointer+4
PhantomCharIDList:
@
