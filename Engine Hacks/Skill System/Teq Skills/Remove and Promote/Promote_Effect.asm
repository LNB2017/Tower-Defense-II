.thumb
.org 0x0

push	{r14}
ldr		r0,Func_4E884 		@I think this clears backgrounds 0 and 2
mov		r14,r0
.short	0xF800
ldr		r0,OptionStruct
add		r0,#0x41
ldrb	r0,[r0]
lsl		r0,#0x1E
cmp		r0,#0x0
blt		SoundOff			@bit 2 is set means no sound effects
ldr		r0,Play_Sound_Func
mov		r14,r0
mov		r0,#0x6A
.short	0xF800
SoundOff:
ldr		r0,Func_3D38
mov		r14,r0
mov		r0,#0x0
.short	0xF800
ldr		r0,Func_3D20
mov		r14,r0
.short	0xF800
ldr		r0,Func_4EF20
mov		r14,r0
.short	0xF800
ldr		r0,ActionStruct
ldr		r1,PromoteActionByte
strb	r1,[r0,#0x11]
mov		r0,#0x21
pop		{r1}
bx		r1

.align
Func_4E884:
.long 0x0804E884
Play_Sound_Func:
.long 0x080D01FC
Func_3D38:
.long 0x08003D38
Func_3D20:
.long 0x08003D20
Func_4EF20:
.long 0x0804EF20
OptionStruct:
.long 0x0202BCF0
ActionStruct:
.long 0x0203A958
PromoteActionByte:
@
