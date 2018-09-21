.thumb

@r0 = location to write to, r1 = tsa, r2 = palette <<0xC (to be orr'd)
@first two bytes of tsa are width and length

push	{r4-r7,r14}
add		sp,#-0x4
mov		r4,r0
str		r0,[sp]
mov		r5,r2
ldrb	r6,[r1]		@width
ldrb	r7,[r1,#1]	@height
mov		r2,#0		@x counter
mov		r3,#0		@y counter
add		r1,#2		@skip the size thing
Loop1:
ldrh	r0,[r1]
add		r0,r5
strh	r0,[r4]
add		r4,#2
add		r1,#2
add		r2,#1
cmp		r2,r6
blt		Loop1
add		r3,#1
cmp		r3,r7
bge		GoBack
mov		r2,#0
ldr		r4,[sp]
lsl		r0,r3,#0x6	@each row is 0x40 byte
add		r4,r0
b		Loop1
GoBack:
add		sp,#0x4
pop		{r4-r7}
pop		{r0}
bx		r0
