.thumb

@jumped to from 2AD90

@r0=char data ptr

push	{r14}
mov		r1,r0
add		r1,#0x30
ldrb	r1,[r1]
lsl		r1,#0x1C
lsr		r1,#0x1C
sub		r1,#5
cmp		r1,#3
bhi		GoBack
adr		r2,BattleStructOffsets
ldrb	r3,[r2,r1]
add		r0,r3
add		r2,#4				@bonuses
ldrb	r3,[r2,r1]
ldrh	r2,[r0]
add		r2,r3
strh	r2,[r0]
GoBack:
pop		{r0}
bx		r0

.align
BattleStructOffsets:
.byte 0x5A, 0x5C, 0x66, 0x62
@
