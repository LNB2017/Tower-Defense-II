.thumb

ldr		r2,[r7,#4]
cmp		r6,#0xFB
blt		NormalStuff
add		r6,r0
ldr		r0,=#0x802C177
bx		r0

NormalStuff:
add		r6,r0
mov		r1,#0
ldrb	r3,[r5]
ldr		r0,=#0x802C151
bx		r0

.ltorg
