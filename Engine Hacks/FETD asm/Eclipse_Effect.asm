.thumb

@called at 2AE24

@r4=attacker struct, r6=defender

ldrb	r0,[r6,#0x13]
add		r0,#1
asr		r0,#1
ldr		r1,[r6]
ldr		r1,[r1,#0x28]
ldr		r2,[r6,#4]
ldr		r2,[r2,#0x28]
orr		r1,r2
ldr		r2,=#0x80008000
tst		r1,r2
beq		StoreDamage
asr		r0,#1			@if boss/assassin, do hp/4 damage
StoreDamage:
mov		r1,r4
add		r1,#0x5A
strh	r0,[r1]
bx		r14

.ltorg
