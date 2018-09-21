.thumb
.org 0

@jumped to from 24CEC
@I believe this function returns the number of units that can move this turn
@on npc phase, we're going to return 0
@r0=phase byte

push	{r4-r6,r14}
mov		r5,r0
mov		r6,#0
add		r4,r5,#1
cmp		r0,#0x40
bne		GoBack
mov		r4,#0x80
GoBack:
ldr		r1,=#0x08024CF5
bx		r1
