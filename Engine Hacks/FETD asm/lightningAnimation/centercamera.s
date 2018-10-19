.thumb

ldr	r0,=0x0202BCBC
ldrh	r2,[r0]		@x camera position on the map, in pixels
ldrh	r3,[r0,#2]	@y camera position on the map, in pixels

ldr	r0,=0x030004B8
ldrb	r1,[r0,#8]	@target y position
ldrb	r0,[r0,#4]	@target x position
lsl	r0,#4		@in pixels (*16)
lsl	r1,#4

@position relative to screen, in pixels
sub	r0,r2
sub	r1,r3

@center effect x
mov	r2,#0x1E
sub	r0,r2
mov	r2,#0
sub	r0,r2,r0
mov	r2,#0xFF
and	r0,r2

@center effect y
mov	r3,#0xAC
sub	r1,r3
mov	r3,#0
sub	r1,r3,r1
mov	r3,#0xFF
and	r1,r3

ldr	r3,=0x03003080

mov	r2,#0x1C
strh	r0,[r3,r2]		@x offset

mov	r2,#0x1E
strh	r1,[r3,r2]		@y offset

bx	lr
