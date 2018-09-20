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
mov		r0,#0x17		@not sure what this is (some kind of bitfield)
pop		{r1}
bx		r1

.align
ActionStruct:
.long 0x0203A958
CallEventEngine:
.long 0x0800D07C
RemoveEvents:
@
