.thumb
.include "_Buy_Unit_Defs.asm"

@r0 = Buy_Unit proc, in case I need it

push	{r14}
ldr		r0,=gChapterData
ldrh	r0,[r0,#0x10]		@turn count
mov		r1,#5
_blh	0x80D167C			@divide
cmp		r0,#20
ble		Label1
mov		r0,#20
Label1:
cmp		r0,#1
bge		Label2
mov		r0,#1
Label2:
pop		{r1}
bx		r1

.ltorg
