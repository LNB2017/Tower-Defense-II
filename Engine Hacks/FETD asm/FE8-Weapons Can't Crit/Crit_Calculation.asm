.thumb

@called from 2ACB0

push	{r14}
ldrb	r0,[r0]		@current item
cmp		r0,#0xB5
beq		NoCrit		@0xB5 = Stone
ldr		r3,=#0x8017624		@GetItemCrit
mov		r14,r3
.short	0xF800
cmp		r0,#0xFF
bne		GoBack
NoCrit:
strh	r4,[r5]
GoBack:
mov		r1,#0
pop		{r2}
bx		r2

.ltorg
