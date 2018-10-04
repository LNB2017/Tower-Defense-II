.thumb

.equ origin, 0x8D288
.equ Text_InitClear, . + 0x3D5C - origin
.equ NewGreenTextColorManager, . + 0x49AC - origin
.equ Text_Clear, . + 0x3DC8 - origin
.equ GetStringFromIndex, . + 0xA240 - origin
.equ GetStringTextWidth, . + 0x3EDC - origin
.equ Text_AppendString, . + 0x4004 - origin
.equ GetPartyGoldAmount, . + 0x24DE8 - origin
.equ Text_AppendDecNumber, . + 0x4074 - origin
.equ StoreNumberStringToSmallBuffer, . + 0x38E0 - origin
.equ Text_InsertString, . + 0x4480 - origin

push	{r4-r7,r14}
mov		r6,r0
add		r0,#0x50
mov		r1,#0
strb	r1,[r0]			@+50
strb	r1,[r0,#6]		@+56
str		r1,[r0,#8]		@+58-5B
mov		r1,#0xFF
strb	r1,[r0,#7]		@+57 (note: I dunno what any of this is for)

@Gold text
mov		r5,r6
add		r5,#0x2C		@text struct 1
mov		r0,r5
mov		r1,#9
bl		Text_InitClear
mov		r0,r5
bl		Text_Clear
ldr		r0,=#0x90E		@Gold: [X]
bl		GetStringFromIndex
mov		r1,r0
mov		r0,r5
bl		Text_AppendString
bl		GetPartyGoldAmount
bl		StoreNumberStringToSmallBuffer
ldr		r7,=#0x2028E44	@where the previous call stores the number string
mov		r0,r7
bl		GetStringTextWidth
mov		r1,#0x48
sub		r1,r1,r0
mov		r0,r5
mov		r2,#2
mov		r3,r7
bl		Text_InsertString

@Wave text
mov		r5,r6
add		r5,#0x34		@text struct 2
mov		r0,r5
mov		r1,#9
bl		Text_InitClear
mov		r0,r5
bl		Text_Clear
mov		r0,r6
bl		NewGreenTextColorManager
ldr		r0,=#0x90F		@Wave in: [X]
bl		GetStringFromIndex
mov		r1,r0
mov		r0,r5
bl		Text_AppendString
ldr		r0,=#0x202BCF0
ldrh	r0,[r0,#0x10]	@turn number
cmp		r0,#100
bgt		ShowFinal
ldr		r1,Enemy_Pointer_Table
mov		r2,#0			@counter
lsl		r3,r0,#2
add		r1,r3
WaveLoop:
ldr		r3,[r1]
cmp		r3,#0
bne		FoundWave
add		r2,#1
add		r1,#4
add		r0,#1
add		r3,r0,r2
cmp		r3,#100
ble		WaveLoop
b		ShowFinal
FoundWave:
cmp		r2,#0
beq		ShowNow
@if we got here, wave is in X turns, X a number
mov		r0,r2
bl		StoreNumberStringToSmallBuffer
ldr		r7,=#0x2028E44	@where the previous call stores the number string
mov 	r4,#2			@text color
b		ShowWaveText

ShowNow:
ldr		r0,=#0x910		@Now![X]
bl		GetStringFromIndex
mov		r7,r0
mov		r4,#4
b		ShowWaveText

ShowFinal:
ldr		r0,=#0x911		@Final![X]
bl		GetStringFromIndex
mov		r7,r0
mov		r4,#4
b		ShowWaveText

ShowWaveText:
mov		r0,r7
bl		GetStringTextWidth
mov		r1,#0x48
sub		r1,r1,r0
mov		r0,r5
mov		r2,r4
mov		r3,r7
bl		Text_InsertString

mov		r0,r6
add		r0,#0x44
mov		r1,#1
strh	r1,[r0]
pop		{r4-r7}
pop		{r0}
bx		r0

.ltorg
Enemy_Pointer_Table:
@
