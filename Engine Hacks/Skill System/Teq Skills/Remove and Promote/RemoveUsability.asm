.thumb
.org 0x0

@return 3 if false (unit is a knight that hasn't used a move item)

.equ RootedID, SkillTester+4

push	{r4,r14}
ldr		r4,CurrentCharPtr
ldr		r4,[r4]
ldr		r1,[r4,#0xC]
mov		r2,#0x40
tst		r1,r2
bne		RetFalse
ldr		r1,[r4,#0x4]
ldrb	r1,[r1,#0x4]
cmp		r1,#0x79		@wagon
beq		RetFalse		@don't want to accidentally destroy the wagon, do we?
mov		r0,r4
ldr		r1,RootedID
ldr		r3,SkillTester
mov		r14,r3
.short	0xF800
cmp		r0,#0
beq		RetTrue
mov		r1,#0x41
ldrb	r1,[r4,r1]
mov		r2,#0x20		@guard bit
tst		r1,r2
bne		RetFalse		@if set and has skill, no removing
RetTrue:
mov		r0,#1
b		GoBack
RetFalse:
mov		r0,#3
GoBack:
pop		{r4}
pop		{r1}
bx		r1

.align
CurrentCharPtr:
.long 0x03004E50
SkillTester:
@
