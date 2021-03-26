.thumb

@get turn number, find relevant pointer to units, and write that to slot 1

.macro blh to, reg=r3
ldr \reg, =\to
mov lr, \reg
.short 0xF800
.endm

.equ MemorySlotC, 0x30004E8

.equ NextRN_N, 0x08000c80

push	{r14}

mov r0, #0 // this will potentially get stored slot2

// Enemy_Pointer_List_Tables offset

ldr		r1,Enemy_Pointer_List_Tables
ldr r2, = MemorySlotC
ldr r2, [r2]
mov r3, #4
mul r2, r3
add r1, r2
ldr r1, [r1]
cmp r1, #0
beq end

ldr		r0,=#0x202BCF0
ldrh	r0,[r0,#0x10]		@turn number
lsl		r0,#2

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
Enemy_Pointer_List_Tables:
@
