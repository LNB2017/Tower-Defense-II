.thumb

@return true if unit has at least 1 weapon rank that isn't 0 or capped

@r4=char data, r5=item id

mov		r3,#1		@assume true
mov		r0,r4
add		r0,#0x28	@beginning of weapon ranks
mov		r1,#0		@counter
WeaponRankLoop:
ldrb	r2,[r0,r1]
cmp		r2,#0
beq		NextRank
cmp		r2,#0xFB
blt		GoBack
NextRank:
add		r1,#1
cmp		r1,#8
blt		WeaponRankLoop
mov		r3,#0
GoBack:
mov		r0,r3
pop		{r4-r5}
pop		{r1}
bx		r1
