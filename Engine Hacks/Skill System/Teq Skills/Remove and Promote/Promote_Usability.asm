.thumb
.org 0x0

push	{r4,r14}
mov		r4,#0x3
ldr		r0,CurrentCharPtr
ldr		r0,[r0]
ldr		r1,[r0,#0xC]
mov		r2,#0x40
tst		r1,r2
bne		GoBack
ldrb	r1,[r0,#0x8]		@current level
cmp		r1,#0x14
blt		GoBack
ldr		r0,[r0,#0x4]
ldrb	r0,[r0,#0x4]		@class id
ldr		r1,PromotionBranchTable
lsl		r0,#0x1
add		r0,r1
ldrb	r0,[r0]
cmp		r0,#0x0
beq		GoBack
mov		r4,#0x1
GoBack:
mov		r0,r4
pop		{r4}
pop		{r1}
bx		r1

.align
CurrentCharPtr:
.long 0x03004E50
PromotionBranchTable:
@
