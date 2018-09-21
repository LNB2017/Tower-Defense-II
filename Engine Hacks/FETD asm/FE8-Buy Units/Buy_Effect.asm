.thumb

push	{r14}
add		r1,#0x3D			@some proc
ldrb	r1,[r1]
cmp		r1,#2
bne		Initialize_Proc
ldr		r1,Cant_Buy_Text_ID
ldr		r2,=#0x804F580		@MenuCallHelpBox
mov		r14,r2
.short	0xF800
mov		r0,#8
b		GoBack

Initialize_Proc:
ldr		r0,Buy_Unit_Proc
mov		r1,#3
ldr		r2,=#0x8002C7C		@Create6C, hopefully it's not supposed to be Create6CBlocking
mov		r14,r2
.short	0xF800
mov		r0,#0x17
GoBack:
pop		{r1}
bx		r1

.ltorg
.set Cant_Buy_Text_ID, Buy_Unit_Proc+4
Buy_Unit_Proc:
@
