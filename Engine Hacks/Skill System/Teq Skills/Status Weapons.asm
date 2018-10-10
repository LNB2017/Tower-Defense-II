.thumb

push	{r4-r5,r14}
mov		r4,r0
mov		r5,r1
ldr		r2,[r5,#4]
cmp		r2,#0
beq		GoBack
add		r0,#0x48
ldrb	r0,[r0]		@attacker's weapon
ldr		r1,StatusWeaponList
StatusLoop:
ldrb	r2,[r1]
cmp		r2,#0
beq		GoBack
cmp		r2,r0
beq		ImplementStatus
add		r1,#2
b		StatusLoop
ImplementStatus:
ldrb	r0,[r1,#1]		@status byte and duration
add		r5,#0x6F
strb	r0,[r5]
GoBack:
pop		{r4-r5}
pop		{r0}
bx		r0

.align
StatusWeaponList:
@
