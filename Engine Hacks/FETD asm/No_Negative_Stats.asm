.thumb
.org 0

@Make sure class+char bases are positive
@called at from 17E64

mov		r3,#0				@used this to branch here
mov		r0,#0x10
ldsb	r0,[r2,r0]
mov		r5,#0x11
ldsb	r5,[r1,r5]
add		r0,r5
cmp		r0,#0
bge		Label1
mov		r0,#0
Label1:
strb	r0,[r4,#0x18]
mov		r0,#0x12
ldsb	r0,[r1,r0]
cmp		r0,#0
bge		Label2
mov		r0,#0
Label2:
strb	r0,[r4,#0x19]
@make sure the other stats aren't negative
mov		r0,#0x12
ldsb	r0,[r4,r0]
cmp		r0,#0
bgt		Label3
mov		r0,#1
strb	r0,[r4,#0x12]			@hp
Label3:
mov		r0,#0x14
ldsb	r0,[r4,r0]
cmp		r0,#0
bge		Label4
strb	r3,[r4,#0x14]			@str
Label4:
mov		r0,#0x15
ldsb	r0,[r4,r0]
cmp		r0,#0
bge		Label5
strb	r3,[r4,#0x15]			@skl
Label5:
mov		r0,#0x16
ldsb	r0,[r4,r0]
cmp		r0,#0
bge		Label6
strb	r3,[r4,#0x16]			@spd
Label6:
mov		r0,#0x17
ldsb	r0,[r4,r0]
cmp		r0,#0
bge		Label7
strb	r3,[r4,#0x17]			@def
Label7:
bx		r14
