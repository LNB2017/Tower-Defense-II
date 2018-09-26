.thumb

@r4=char data, r5=item id

mov		r0,#0
mov		r1,#0x41
ldrb	r1,[r4,r1]
mov		r2,#0x20
tst		r1,r2
beq		GoBack
mov		r0,#1
GoBack:
pop		{r4-r5}
pop		{r1}
bx		r1
