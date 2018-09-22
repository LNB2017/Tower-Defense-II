.thumb

@jumped to from 12F50

push	{r4-r5,r14}
cmp		r0,#0
bne		RegularStuff
ldr		r0,=#0x8012F81
bx		r0

RegularStuff:
mov		r3,r0
mov		r4,r1
mov		r0,#0xFA
ldr		r1,=#0x8012F59
bx		r1

.ltorg
