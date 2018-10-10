.thumb

@cmp		r0,#0
@beq		CheckForCantCrit
@add		r2,#25
@mov		r1,#0x66
@strh	r2,[r4,r1]
@CheckForCantCrit:
mov		r0,#0x48
ldrh	r0,[r4,r0]
ldr		r3,=#0x8017624		@GetItemCrit
mov		r14,r3
.short	0xF800
cmp		r0,#0xFF
bne		GoBack
lsl		r0,#0x18
asr		r0,#0x18
add		r4,#0x66
strh	r0,[r4]
GoBack:
pop		{r4}
pop		{r0}
bx		r0

.ltorg
