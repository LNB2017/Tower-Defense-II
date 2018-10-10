.thumb

@jumped to from 2794C

@r5 is free, r2 is supposed to be rom char data ptr ([r4+0x0])
@r0=class and char abilities word

mov		r5,#0				@flag
cmp		r0,#0
bne		CheckPositioning
mov		r0,#0x80
lsl		r0,#0x18			@assassin flag
and		r0,r1
cmp		r0,#0
beq		NoIcons
mov		r5,#1
b		CheckPositioning
NoIcons:
ldr		r0,=#0x80279B1		@checks for the 'protect unit' icon, I think
bx		r0

CheckPositioning:
ldrb	r1,[r4,#0x10]
lsl		r1,#4
ldr		r2,=#0x202BCB0
mov		r0,#0xC
ldsh	r0,[r2,r0]
sub		r3,r1,r0
ldrb	r0,[r4,#0x11]
lsl		r0,#4
mov		r1,#0xE
ldsh	r1,[r2,r1]
sub		r2,r0,r1
cmp		r3,#0xF0
bhi		GoToNextUnit
cmp		r2,#0xA0
bhi		GoToNextUnit
ldr		r0,=#0x209
add		r0,r3
ldr		r1,=#0x1FF
and		r0,r1				@relative x coordinate
ldr		r1,=#0x107
add		r1,r2
mov		r2,#0xFF
and		r1,r2
ldr		r2,=#0x8590F44		@gOAM_8x8Obj
cmp		r5,#0
beq		BossShield
ldr		r3,=#0x876			@! icon atm
b		ShowIcon
BossShield:
ldr		r3,=#0x810
ShowIcon:
ldr		r5,=#0x8002BB8		@PushToHiOAM
mov		r14,r5
.short	0xF800
GoToNextUnit:
ldr		r0,=#0x80279FD
bx		r0

.ltorg
