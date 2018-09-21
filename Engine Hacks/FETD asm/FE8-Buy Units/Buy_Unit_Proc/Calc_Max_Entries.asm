.thumb
.include "_Buy_Unit_Defs.asm"

@r0 = Buy_Unit proc
@+2C is tab number (0 for unpromoted unit list, 1 for promoted unit list). We calculate the number of classes in the table and write that to +32

push	{r14}
ldrh	r1,[r0,#0x2C]
lsl		r1,#2
adr		r2,Unit_Lists
ldr		r1,[r2,r1]
mov		r3,#0
Loop1:
ldrb	r2,[r1]
cmp		r2,#0
beq		StoreAnswer
add		r3,#1
add		r1,#8
b		Loop1
StoreAnswer:
strh	r3,[r0,#0x32]
pop		{r0}
bx		r0

.align
Unit_Lists:
@
