.thumb
.include "_Buy_Unit_Defs.asm"

@r0=Buy_Unit proc, r1=entry #
@+0x2C is the tab number, 0 for unpromoted, 1 for promoted, 0x32 is max number of entries in table

push	{r14}
ldrh	r2,[r0,#0x32]		@number of entries in table
cmp		r1,r2
bge		RetZero
ldrh	r2,[r0,#0x2C]
lsl		r2,#2
adr		r3,Unit_Lists
ldr		r2,[r3,r2]
lsl		r1,#3
add		r0,r1,r2
b		GoBack
RetZero:
mov		r0,#0
GoBack:
pop		{r1}
bx		r1

.align
Unit_Lists:
@
