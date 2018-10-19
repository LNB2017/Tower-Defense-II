.thumb

.macro _blh to, reg=r3
	ldr \reg, =\to
	mov lr, \reg
	.short 0xF800
.endm

mov		r0,r6
bl		RelocateEffect
ldr		r0,=#0x802FF77
bx		r0

@r0=proc
RelocateEffect:
push	{r4-r7,r14}
mov		r4,r0
ldr		r5,=#0x203A958
ldrb	r0,[r5,#0xC]
_blh	0x8019430				@GetChar
mov		r6,r0
ldrb	r1,[r5,#0x12]			@item slot
_blh	0x8018994				@UnitDecreaseItemUse
ldrb	r1,[r5,#0x12]
lsl		r1,#1
add		r1,#0x1E
ldrh	r5,[r6,r1]				@item
ldr		r0,[r6]
ldr		r0,[r0,#0x28]
ldr		r1,[r6,#4]
ldr		r1,[r1,#0x28]
orr		r0,r1
mov		r7,#251
mov		r1,#1
lsl		r1,#8
tst		r0,r1
bne		Label1
mov		r7,#181					@unpromoted units can't go above A rank
Label1:
mov		r2,r6
add		r2,#0x28
mov		r3,#0
WeaponRankLoop:
ldrb	r0,[r2,r3]
cmp		r0,#0
beq		NextRank
cmp		r0,r7
bge		NextRank
mov		r1,#31					@D
cmp		r0,r1
blt		StoreWeaponExp
mov		r1,#71					@C
cmp		r0,r1
blt 	StoreWeaponExp
mov		r1,#121					@B
cmp		r0,r1
blt		StoreWeaponExp
mov		r1,#181					@A
cmp		r0,r1
blt		StoreWeaponExp
mov		r1,#251					@S
StoreWeaponExp:
strb	r1,[r2,r3]
NextRank:
add		r3,#1
cmp		r3,#8
blt		WeaponRankLoop

ldr		r0,=#0x203A56C
add		r0,#0x6F
mov		r1,#0xFF
strb	r1,[r0]					@I have no idea why this is here, but the ExecStatBooster at 2F914 does it

ldr		r0,=#0x202BCF0			@gChapterData
add		r0,#0x41
ldrb	r0,[r0]
lsl		r0,#0x1E
cmp		r0,#0
blt		NoSound
mov		r0,#0x5A
_blh	0x80D01FC				@PlaySound
NoSound:
mov		r0,r5
_blh	0x8017700				@GetItemIconID
mov		r5,r0
ldr		r0,ArmsScrollUseText
_blh	0x800A240				@GetStringFromIndex
mov		r2,r0
mov		r0,r4
mov		r1,r5
_blh	0x801F9FC				@makes the popup
pop		{r4-r7}
pop		{r0}
bx		r0

.ltorg
ArmsScrollUseText:
@
