.thumb

mov		r0,r6
bl		RelocateEffect
ldr		r0,=#0x802FF77
bx		r0

@r0=proc
RelocateEffect:

push	{r4-r6,r14}
mov		r4,r0
ldr		r5,=#0x203A958
ldrb	r0,[r5,#0xC]
ldr		r3,=#0x8019430
mov		r14,r3
.short	0xF800
mov		r6,r0
ldrb	r1,[r5,#0x12]			@item slot
ldr		r3,=#0x802CB24			@SetupSubjectBattleUnitForStaff
mov		r14,r3
.short	0xF800
mov		r0,#0x41
ldrb	r1,[r6,r0]
mov		r2,#0xDF
and		r1,r2
strb	r1,[r6,r0]
ldr		r0,=#0x30004B8
mov		r1,#9
lsl		r1,#2
add		r0,r1
mov		r1,#0x79				@0x79 in slot 9 indicates unit used Relocate this turn
str		r1,[r0]
mov		r0,r4
ldr		r3,=#0x802CC54			@not sure
mov		r14,r3
.short	0xF800
ldr		r3,=#0x802CA14			@BeginBattleAnimations
mov		r14,r3
.short	0xF800
pop		{r4-r6}
pop		{r0}
bx		r0

.ltorg
