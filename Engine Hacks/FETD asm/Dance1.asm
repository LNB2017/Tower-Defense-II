.thumb

@called at 23238

push	{r14}
ldr		r3,=#0x802951C		@for fortify
mov		r14,r3
.short	0xF800
ldr		r1,=#0x203A958
mov		r0,#4
strb	r0,[r1,#0x11]		@action byte, 4 = dance
mov		r0,#0x37
pop		{r1}
bx		r1

.ltorg
