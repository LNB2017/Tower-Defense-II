.thumb
.org 0

push	{r14}
ldr		r0,CallEventEngine
mov		r14,r0
ldr		r0,RemoveEvents
mov		r1,#0
.short	0xF800
ldr		r0,ActionStruct
mov 	r1,#1
strb	r1,[r0,#0x11]
ldr		r0,=#0x30004B8
mov		r1,#9
lsl		r1,#2
add		r0,r1
mov		r1,#0x79			@0x79 in slot 9 indicates unit used Relocate or is being removed
str		r1,[r0]
mov		r0,#0x17		@not sure what this is (some kind of bitfield)
pop		{r1}
bx		r1

.ltorg
ActionStruct:
.long 0x0203A958
CallEventEngine:
.long 0x0800D07C
RemoveEvents:
@
