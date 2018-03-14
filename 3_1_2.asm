org 8100h

start:
	mov ax, cs
	mov ds, ax
	mov bp, msg2
	mov ax, ds
	mov es, ax
	mov cx, msg2len
	mov ax, 1301h
	mov bx, 0007h
	mov dh, 1
	mov dl, 0
	int 10h
	ret

msg2:
	db 'WoW!!!'
msg2len equ ($-msg2)
	