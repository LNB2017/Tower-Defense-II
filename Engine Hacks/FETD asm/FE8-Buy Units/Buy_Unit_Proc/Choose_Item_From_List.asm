.thumb

ChooseItemFromList:
@r0=random number, r1=pointer to list
mov		r3,#0
ListLoop:
ldrb	r2,[r1,#1]		@chance of getting item
cmp		r2,#0
beq		ReturnNoItem
add		r3,r2
cmp		r0,r3
bge		NextEntry
ldrb	r0,[r1]			@item
b		ReturnItem
NextEntry:
add		r1,#2
b		ListLoop
ReturnNoItem:
mov		r0,#0
ReturnItem:
bx		r14
