.thumb
.org 0x0

@r0=battle struct or char data ptr
ldr		r1,[r0]
mov		r2,#33
ldsb	r1,[r1,r2]		@res growth
ldr		r2,[r0,#4]
mov		r3,#32
ldrb	r2,[r2,r3]
add		r1,r2
mov		r2,#15		@index of res boost
ldr		r3,Extra_Growth_Boosts
bx		r3

.align
Extra_Growth_Boosts:
@
