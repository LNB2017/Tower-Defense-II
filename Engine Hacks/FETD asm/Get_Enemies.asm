.thumb

@get turn number, find relevant pointer to units, and write that to slot 1

.macro blh to, reg=r3
ldr \reg, =\to
mov lr, \reg
.short 0xF800
.endm

.equ NextRN_N, 0x08000c80

push	{r14}
ldr		r0,=#0x202BCF0
ldrh	r0,[r0,#0x10]		@turn number
lsl		r0,#2
ldr		r1,Enemy_Pointer_List_Table
add		r0,r1
ldr r0, [r0]
cmp r0, #0
beq end

mov r4, r0 // r4 = list
ldr r0, [r4] // # number of groups to pick from
cmp r0, #0
beq end
add r4, #4 // go to the enemy groups
blh NextRN_N
mov r1, #4
mul r0, r1
ldr r0, [r4, r0] // enemy group list + offset * 4

end:
ldr		r1,=#0x30004B8
str		r0,[r1,#8]			@store to slot 1
pop		{r0}
bx		r0

.ltorg
Enemy_Pointer_List_Table:
@
