.thumb

@get turn number, find relevant pointer to units, and write that to slot 1

push	{r14}
ldr		r0,=#0x202BCF0
ldrh	r0,[r0,#0x10]		@turn number
lsl		r0,#2
ldr		r1,Enemy_Pointer_Table
add		r0,r1
ldr		r0,[r0]
ldr		r1,=#0x30004B8
str		r0,[r1,#8]			@store to slot 1
pop		{r0}
bx		r0

.ltorg
Enemy_Pointer_Table:
@
