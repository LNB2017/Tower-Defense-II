.thumb

@r4=attacker's actual data, r5=defender's actual data ptr, r6=action struct

push	{r14}
ldrb	r0,[r6,#0x11]
cmp		r0,#2
bne		GoBack
mov		r0,r4
bl		DecrementUses
mov		r0,r5
bl		DecrementUses
GoBack:
pop		{r0}
bx		r0

DecrementUses:
@r0=unit ptr
push	{r4-r7,r14}
mov		r4,r0
mov		r5,r4
add		r5,#0x1E
mov		r6,#0		@inventory counter
mov		r7,#0		@flag to indicate we need rearranging if a skill was used up
InventoryLoop:
ldrb	r0,[r5]
cmp		r0,#0
beq		EndDecrementing
ldr		r3,=#0x80177B0	@get item data
mov		r14,r3
.short	0xF800
add		r0,#0x23
ldrb	r0,[r0]
cmp		r0,#0
beq		NextItem
ldrh	r0,[r5]
ldr		r3,=#0x8016AEC	@GetItemAfterUse
mov		r14,r3
.short	0xF800
strh	r0,[r5]
cmp		r0,#0
bne		NextItem
mov		r7,#1
NextItem:
add		r5,#2
add		r6,#1
cmp		r6,#4
ble		InventoryLoop

EndDecrementing:
cmp		r7,#0
beq		End
mov		r0,r4
ldr		r3,=#0x8017984	@RemoveBlankItems
mov		r14,r3
.short	0xF800
End:
pop		{r4-r7}
pop		{r0}
bx		r0

.ltorg
