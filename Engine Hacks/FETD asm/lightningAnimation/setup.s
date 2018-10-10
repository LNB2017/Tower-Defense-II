.thumb
push	{r4,lr}
mov	r4,r0
sub	sp,#4
mov	r1,#0x67
mov	r2,#0x00
strb	r2,[r0,r1]	@reset the counter
nop
mov	r1,#0x68
ldr	r2,pointer
str	r2,[r0,r1]	@write the pointer


ldr	r0,=#0x2022CA8
mov	r1,#0
ldr	r3,=#0x8001220	@FillBgMap

@special effects

@move camera based on setval
ldr	r0,=0x030004B8
ldrb	r1,[r0,#4]
ldrb	r2,[r0,#8]
mov	r0,r4
ldr	r3,=0x8015E0C
mov	lr,r3
.short	0xF800

ldr	r0,=0x030004B8
ldrb	r1,[r0,#4]
ldrb	r2,[r0,#8]
	mov	r2,#0
mov 	r0, r4

push 	{r4-r6}
mov 	r6, r0
mov 	r4, r1
mov 	r5, r2

lsl 	r0, r4, #0x4
ldr 	r2,=0x202BCB0
mov 	r3, #0xC
ldsh 	r1, [r2, r3]
sub 	r0, r0, r1
mov 	r4, r0
sub 	r4, #0x18
lsl 	r0, r5, #0x4
mov 	r3, #0xE
ldsh 	r1, [r2, r3]
sub 	r0, r0, r1
mov 	r5, r0
sub 	r5, #0x28
neg 	r1, r4
lsl 	r1, r1, #0x10
lsr 	r1, r1, #0x10
neg 	r2, r5
lsl 	r2, r2, #0x10
lsr 	r2, r2, #0x10
mov 	r0, #0x0
ldr 	r3,=0x800148C 		@store location of where light run animation will play
mov 	r14, r3
.short 0xF800

pop 	{r4-r6}

@ --

ldr	r0,=0x03003080
mov	r1,#0x3C
ldr	r2,=0x3841
strh	r2,[r0,r1]	@Color Special Effects Selection

mov	r1,#0x44
ldr	r2,=0x1010
strh	r2,[r0,r1]	@Alpha Blending Coefficients

mov	r1,#0x1C
ldrh	r2,[r0,r1]		@x offset
add	r2,#8
strh	r2,[r0,r1]		@x offset

mov	r1,#0x1E
mov	r2,#16			@center
ldrh	r2,[r0,r1]		@y offset
add	r2,#40
strh	r2,[r0,r1]		@y offset

mov	r2,#0x10
strh	r2,[r0,r1]		@y offset

@0x120 = X coord 0 on the screen, sub 0x10 from it to move 1 tile to the right, 0xAC for the center

@load the palette
mov	r1,#0x68
ldr	r0,[r4,r1]	@load the pointer
ldr	r0,[r0,#8]	@load the palette
cmp	r0,#0
beq	nopalette
ldr	r1,=#0xFFFFFFFF
cmp	r0,r1
beq	nopalette
mov	r1,#0x40
mov	r2,#0x20
ldr	r3,=#0x08000DB8	@CopyToPaletteBuffer
mov	lr,r3
.short	0xF800

ldr	r0,=#0x300000E
mov	r1,#1
strb	r1,[r0]

nopalette:

add	sp,#4
pop	{r4}
pop	{r0}
bx	r0

.align
.ltorg

pointer:

