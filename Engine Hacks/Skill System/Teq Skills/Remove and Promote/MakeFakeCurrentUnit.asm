.thumb
.org 0x0

@makes a fake current character so that you can run events on the actual current character

ldr r0, ActiveUnit
ldr r1, NoUnit
str r1,[r0]
mov r0, #0xFF
strb r0,[r1,#0xC]
ldr r2, CursorLoc
ldrb r0,[r2] @y
strb r0,[r1,#0x11]
ldrb r0,[r2,#2] @x
strb r0,[r1,#0x10]
bx   r14

.align
ActiveUnit:
.long 0x03004E50
NoUnit:
.long 0x03004E70
CursorLoc:
.long 0x0202BCC6
