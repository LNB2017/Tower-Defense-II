.thumb

@r0,r4 = char data ptr
@ret false if unit is petrified or is dancer

add		r0,#0x30
ldrb	r0,[r0]
mov		r1,#0xF
and		r1,r0
cmp		r1,#0xB
beq		RetFalse
cmp		r1,#0xD
beq		RetFalse
ldr		r0,[r4]
ldr		r0,[r0,#0x28]
ldr		r1,[r4,#4]
ldr		r1,[r1,#0x28]
orr		r0,r1
mov		r1,#0x30
tst		r0,r1
bne		RetFalse
mov		r0,#1
b		GoBack
RetFalse:
mov		r0,#0
GoBack:
bx		r14
