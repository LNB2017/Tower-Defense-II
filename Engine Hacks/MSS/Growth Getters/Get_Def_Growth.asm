.thumb
.org 0x0

@r0=battle struct or char data ptr
ldr		r1,[r0]
mov		r2,#32
ldsb	r1,[r1,r2]		@def growth
ldr		r2,[r0,#4]
ldrb	r2,[r2,#31]
add		r1,r2
cmp 	r1, #0
bge     Cont
mov		r1, #0
Cont:
mov		r2,#14		@index of def boost
ldr		r3,Extra_Growth_Boosts
bx		r3

.align
Extra_Growth_Boosts:
@
