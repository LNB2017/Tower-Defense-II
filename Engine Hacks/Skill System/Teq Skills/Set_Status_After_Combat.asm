.thumb

@called at 2C214

push	{r14}
cmp		r0,#0
blt		GoBack
mov		r1,#0xF0
and		r1,r0
cmp		r1,#0
bne		SetStatusWithTime
mov		r1,r0
mov		r0,r4
ldr		r3,=#0x80178D8		@SetUnitNewStatus
mov		r14,r3
.short	0xF800
b		GoBack
SetStatusWithTime:
mov		r1,#0x30
strb	r0,[r4,r1]
GoBack:
pop		{r0}
bx		r0

.ltorg
