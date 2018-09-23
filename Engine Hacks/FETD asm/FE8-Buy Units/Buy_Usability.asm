.thumb

push	{r4-r6,r14}
mov		r0,#3				@assume false
ldr		r1,=#0x202BCB0
mov		r2,#0x16
ldsh	r4,[r1,r2]			@cursor y
lsl		r4,#2
ldr		r3,=#0x202E4D8		@unit map
ldr		r3,[r3]
ldr		r3,[r3,r4]
mov		r2,#0x14			@cursor x
ldsh	r5,[r1,r2]
ldrb	r3,[r3,r5]
cmp		r3,#0
bne		GoBack				@if there's a unit at this spot, don't bring up option
ldr		r3,=#0x202E4DC		@terrain map
ldr		r3,[r3]
ldr		r3,[r3,r4]
ldrb	r3,[r3,r5]
ldr		r2,=#0x880B808		@eirika lord movement cost table
ldrb	r2,[r2,r3]			@movement cost for this tile
cmp		r2,#0xFF
beq		GoBack
mov		r0,#0
ldr		r1,=#0x8017838		@get empty data ptr
mov		r14,r1
.short	0xF800
cmp		r0,#0
beq		Ret2
mov		r0,#1
b		GoBack
Ret2:
mov		r0,#2
GoBack:
pop		{r4-r6}
pop		{r1}
bx		r1

.ltorg

