.thumb

mov		r0,#1
ldr		r1,=#0x3004E50
ldr		r1,[r1]
ldr		r1,[r1,#4]
ldrb	r1,[r1,#4]
cmp		r1,#0x51
bne		GoBack
mov		r0,#3
GoBack:
bx		r14

.ltorg
