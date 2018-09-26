.thumb
.org 0x0
.equ PassID, SkillTester+4
.equ PassableID, PassID+4

@Bx'd to from 3003D28
@This function sets the Z flag if the moving unit can cross the other unit's tile, either because they're either both allied/npcs or enemies, or because the mover has Pass
push  {r0-r6,r14}   @actually necessary to push the scratch registers in this case

ldrb  r4,[r3,#0xA]  @allegiance byte of current unit
mov		r0,#0x80
and		r0,r4
cmp		r0,#0
beq		GoBack		@if player unit, then they can go anywhere, so set Z flag

eor   r4,r7     @r7 is allegiance byte of unit on tile we are looking at
mov   r0,#0x80
tst   r0,r4
beq   GoBack      @if non-zero, then one character is an enemy and one is not. If zero, the z flag is set

@check for Incorporeal skill for target
ldr		r0,GetCharData
mov		r14,r0
mov		r0,r7
.short	0xF800
ldr		r1,SkillTester
mov		r14,r1
ldr		r1,PassableID
.short	0xF800
cmp		r0,#1		@set z flag if enemy has Passable
beq		GoBack

ldr   r0,GetCharData
mov   r14,r0
ldrb  r0,[r3,#0xA]
.short  0xF800      @returns char data pointer of moving unit
ldr   r1,SkillTester
mov   r14,r1
ldr   r1,PassID
.short  0xF800
cmp   r0,#0x1     @set z flag if unit has Pass
GoBack:
pop   {r0-r6}
pop   {r4}
mov   r14,r4
ldr   r4,GoBackAddress
bx    r4

.align
GetCharData:
.long 0x08019430
GoBackAddress:
.long 0x03003D34    @note that we need to switch back to arm
SkillTester:
@POIN SkillTester
@WORD PassID
