.thumb

push	{r14}
ldr		r0,Gold_Per_Level
ldr		r3,=#0x8024E20
mov		r14,r3
.short	0xF800
pop		{r0}
bx		r0

.ltorg
Gold_Per_Level:
@
