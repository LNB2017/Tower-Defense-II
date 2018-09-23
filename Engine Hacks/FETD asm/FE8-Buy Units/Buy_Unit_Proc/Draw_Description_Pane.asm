.thumb
.include "_Buy_Unit_Defs.asm"

@r0 = Buy_Unit_Proc

.macro Make_Stat growth, base, max, index, label_name
	mov		r0,#(\growth)
	ldrb	r0,[r5,r0]
	mul		r0,r7
	mov		r1,#100
	_blh	Divide
	mov		r1,#(\base)
	ldrb	r1,[r5,r1]
	add		r0,r1
	mov		r1,#(\max)
	ldrb	r1,[r5,r1]
	cmp		r0,r1
	ble		\label_name
	mov		r0,r1
	\label_name:
	mov		r1,sp
	strb	r0,[r1,#(\index)]
.endm

.equ StatNumberPlace, (BGLayer1 + 0x40*StatY + 0x2*(StatX+4))
.equ LvlNumberPlace, (BGLayer1 + 0x40*Desc2Y + 2*(Desc2X+4))
.equ PromotionNamePlace, (BGLayer1 + 0x40*(Desc2Y+4) + 2*Desc2X)
.equ WeaponIconPlace, (BGLayer1 + 0x40*(Desc2Y+10) + 2*Desc2X)
.equ SkillIconPlace, (BGLayer1 + 0x40*(Desc2Y+14) + 2*Desc2X)

push	{r4-r7,r14}
add		sp,#-0x8
mov		r4,r0

@clear the tiles used for stuff previously
ldr		r5,=StatNumberPlace
mov		r6,#0
ClearStatNameLoop:
mov		r0,r5
mov		r1,#2					@number of tiles to clear
_blh	0x80B4EB4
add		r5,#0x80
add		r6,#1
cmp		r6,#8
blt		ClearStatNameLoop
@Lvl
ldr		r0,=LvlNumberPlace
mov		r1,#2
_blh	0x80B4EB4
@Promotion options don't need to be cleared because we just write right over them
@we do need to clear weapon icons, though
ldr		r0,=WeaponIconPlace+16
mov		r1,#9
_blh	0x80B4EB4
@and skill icons, I guess
ldr		r0,=SkillIconPlace+16
mov		r1,#9
_blh	0x80B4EB4

mov		r0,r4
ldrh	r1,[r4,#0x2E]			@current slot number
ldr		r3,Get_Entry_Pointer
_blr	r3
ldrb	r0,[r0]					@class id
_blh	Get_Class_Data
mov		r5,r0					@class data
ldr		r3,Get_Unit_Level
_blr	r3
ldr		r1,[r5,#0x28]
mov		r2,#1
lsl		r2,#8
tst		r1,r2
beq		StoreLevel
lsr		r0,#1					@promoted units are level/2
StoreLevel:
mov		r6,r0
sub		r7,r6,#1				@number of autolevels
ldr		r0,[r5,#0x28]
mov		r1,#1
lsl		r1,#8					@is_promoted flag
tst		r0,r1
beq		CalculateStats
@if promoted, we add a number of autolevels
_blh	0x8037B44				@GetCurrentPromotedLevelBonus
add		r7,r0
CalculateStats:
@r4=proc, r5=class data ptr, r6=actual level, r7=number of autolevels

Make_Stat 27, 11, 19, 0, Label0 @hp
Make_Stat 28, 12, 20, 1, Label1 @str
Make_Stat 29, 13, 21, 2, Label2 @skl
Make_Stat 30, 14, 22, 3, Label3 @spd

mov		r0,#33			@luck
ldrb	r0,[r5,r0]
mul 	r0,r7
mov		r1,#100
_blh	Divide
cmp		r0,#30
ble		Label4
mov		r0,#30
Label4:
mov		r1,sp
strb	r0,[r1,#4]

Make_Stat 31, 15, 23, 5, Label5 @def
Make_Stat 32, 16, 24, 6, Label6 @res

mov		r0,#17			@con
ldrb	r0,[r5,r0]
mov		r1,sp
strb	r0,[r1,#7]

@write stat numbers to screen
mov		r7,#0
StatNumberWriteLoop:
ldr		r0,=StatNumberPlace
lsl		r1,r7,#7
add		r0,r1
mov		r1,#0		@palette id
mov		r2,sp
ldrb	r2,[r2,r7]	@number
_blh	WriteDecNumber
add		r7,#1
cmp		r7,#8
blt		StatNumberWriteLoop

@write level
ldr		r0,=LvlNumberPlace
mov		r1,#0
mov		r2,r6
_blh	WriteDecNumber

@Write promotion options
ldr		r6,[r4,#0x44]		@text struct pointers for the 2 promotion options
mov		r0,r6
_blh	Text_Clear
mov		r0,r6
add		r0,#8
_blh	Text_Clear
ldr		r7,PromotionTable
ldrb	r0,[r5,#4]			@class id
lsl		r0,#1
add		r7,r0
ldrb	r0,[r7]
cmp		r0,#0
beq		Promo1IsBlank
_blh	Get_Class_Data
ldrh	r0,[r0]				@class name
b		Promo1Name
Promo1IsBlank:
ldr		r0,=#0x536			@ --- Text
Promo1Name:
_blh	GetStringFromIndex
mov		r1,r0
mov		r0,r6
_blh	Text_AppendString
mov		r0,r6
ldr		r1,=(PromotionNamePlace)
_blh	Text_Draw
add		r6,#8
ldrb	r0,[r7,#1]
cmp		r0,#0
beq		Promo2IsBlank
_blh	Get_Class_Data
ldrh	r0,[r0]				@class name
b		Promo2Name
Promo2IsBlank:
ldr		r0,=#0x536			@ --- Text
Promo2Name:
_blh	GetStringFromIndex
mov		r1,r0
mov		r0,r6
_blh	Text_AppendString
mov		r0,r6
ldr		r1,=(PromotionNamePlace+0x80)
_blh	Text_Draw

@draw weapon icons
mov		r0,#1
mov		r1,#5				@palette bank
_blh	0x80035D4			@LoadIconPalette
mov		r7,#0
mov		r6,#0
WeaponIconLoop:
mov		r0,#0x2C			@class base weapon ranks
add		r0,r5
ldrb	r0,[r0,r7]
cmp		r0,#0
beq		NextWeaponRank
ldr		r0,=WeaponIconPlace
lsl		r1,r6,#2
add		r0,r1
mov		r1,#0x70			@sword weapon icon
add		r1,r7
mov		r2,#5
lsl		r2,#0xC				@palette bank
_blh	DrawIcon
add		r6,#1
cmp		r6,#4
bgt		WeaponRankFinished	@on the off chance the unit has more than 4 weapon ranks
NextWeaponRank:
add		r7,#1
cmp		r7,#8
blt		WeaponIconLoop
WeaponRankFinished:

@draw skills
mov		r0,#0
mov		r1,#4				@palette bank
_blh	0x80035D4			@LoadIconPalette
mov		r6,#0
ldr		r0,ClassSkillTable
ldrb	r1,[r5,#4]
ldrb	r1,[r0,r1]			@class skill
cmp		r1,#0
beq		OtherSkills
mov		r0,#1
lsl		r0,#8
orr		r1,r0				@0x01 0xSkillIcon
ldr		r0,=SkillIconPlace
mov		r2,#0x40
lsl		r2,#8
_blh	DrawIcon
add		r6,#1
OtherSkills:
ldrb	r0,[r5,#4]			@class id
lsl		r0,#2
ldr		r7,LevelUpSkillTable
add		r7,r0
ldr		r7,[r7]				@learned skills pointer
cmp		r7,#0
beq		SkillFinished
ldr		r3,Get_Unit_Level
_blr	r3
str		r0,[sp]
LearnedSkillLoop:
ldrb	r0,[r7]
cmp		r0,#0
beq		SkillFinished
cmp		r0,#0xFF
beq		UnitHasSkill
ldr		r1,[sp]
cmp		r0,r1
bgt		GetNextLearnedSkill
UnitHasSkill:
ldr		r0,=SkillIconPlace
lsl		r1,r6,#2
add		r0,r1
ldrb	r1,[r7,#1]			@skill icon
mov		r2,#1
lsl		r2,#8
orr		r1,r2
mov		r2,#0x40
lsl		r2,#8
_blh	DrawIcon
add		r6,#1
GetNextLearnedSkill:
cmp		r6,#4
bge		SkillFinished
add		r7,#2
b		LearnedSkillLoop
SkillFinished:

mov		r0,#2
_blh	EnableBGSyncByMask
add		sp,#0x8
pop		{r4-r7}
pop		{r1}
bx		r1

.ltorg
.equ Get_Unit_Level, Get_Entry_Pointer+4
.equ PromotionTable, Get_Unit_Level+4
.equ ClassSkillTable, PromotionTable+4
.equ LevelUpSkillTable, ClassSkillTable+4
Get_Entry_Pointer:
@
