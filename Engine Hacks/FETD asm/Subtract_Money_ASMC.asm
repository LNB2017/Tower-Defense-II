.thumb

ldr		r0,=#0x202BCF0
ldr		r1,[r0,#8]
ldr		r3,=#0x30004B8
ldr		r2,[r3,#4]		@slot 1
sub		r1,r2
cmp		r1,#0
bge		Label1
mov		r1,#0
Label1:
str		r1,[r0,#8]
bx		r14

.ltorg
