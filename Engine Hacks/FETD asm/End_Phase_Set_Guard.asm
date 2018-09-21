.thumb
.org 0

@called at 1882C
@don't modify r2 or r3
ldr		r0,[r1]
cmp		r0,#0
beq		GoBack
ldr		r0,[r1,#0xC]
and		r0,r4
str		r0,[r1,#0xC]
ldrb	r0,[r1,#0xB]
cmp		r0,#0x40
bge		GoBack			@only setting guard tile ai for player units
ldr		r0,[r1,#0x4]
ldrb	r0,[r0,#0x4]
cmp		r0,#0x79
beq		GoBack			@tent doesn't get this set
mov		r0,#0x41
add		r1,r0
ldrb	r0,[r1]
push	{r2}
mov		r2,#0x20
orr		r0,r2
pop		{r2}
strb	r0,[r1]
GoBack:
bx		r14
