.thumb
.org 0

@called from 18750
@Sets bit 0x2 in the status word if unit isn't a wagon, and also sets guard ai bit if allied
@r6=current unit pointer, 4 and r5 are free
push	{r14}
ldr		r2,[r6]
ldr		r0,[r2,#0x4]
ldrb	r0,[r0,#0x4]
cmp		r0,#0x79		@is wagon?
beq		DontSetBit2

ldr		r0,MemorySlots
mov		r1,#9
lsl		r1,#2
add		r0,r1
ldr		r1,[r0]
cmp		r1,#0x79		@memory slot 9 contains this number if the unit has used the Relocate item this turn
bne		NormalEndUnitTurn
mov		r1,#0
str		r1,[r0]			@zero out this memory slot

DontSetBit2:
ldr		r0,[r2,#0xC]
mov		r1,#0x40
mvn		r1,r1
and		r0,r1
str		r0,[r2,#0xC]	@remove 'is cantoing' bit, just in case
b		GoBack

NormalEndUnitTurn:
ldrb	r5,[r2,#0xB]
mov		r0,#0xC0
tst		r0,r5
bne		SetBit2			@if not ally, skip this part
mov		r0,#0x41
add		r0,r2
ldrb	r1,[r0]			@AI byte 4
mov		r3,#0x20		@Guard bit
orr		r1,r3
strb	r1,[r0]

SetBit2:
ldr		r0,[r2,#0xC]
mov		r1,#2
orr		r0,r1
str		r0,[r2,#0xC]

GoBack:
ldr		r0,[r2]
ldrb	r0,[r0,#0x4]
ldr		r1,ActionStruct
pop		{r2}
bx		r2

.align
MemorySlots:
.long 0x030004B8
ActionStruct:
.long 0x0203A958
