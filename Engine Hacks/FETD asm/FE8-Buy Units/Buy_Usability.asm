.thumb

push	{r14}
mov		r0,#3				@assume false
ldr		r1,=#0x202BCB0
mov		r2,#0x16
ldsh	r2,[r1,r2]			@cursor x
lsl		r2,#2
ldr		r3,=#0x202E4D8		@unit map
ldr		r3,[r3]
ldr		r3,[r3,r2]
mov		r2,#0x14			@cursor y
ldsh	r2,[r1,r2]
ldrb	r3,[r3,r2]
cmp		r3,#0
bne		GoBack				@if there's a unit at this spot, don't bring up option
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
pop		{r1}
bx		r1

.ltorg

