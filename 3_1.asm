org 7c00h

Offset1 equ 8100h

start:
	mov ax, cs
	mov ds, ax
	mov bp, msg1
	mov ax, ds
	mov es, ax
	mov cx, msg1len
	mov ax, 1301h
	mov bx, 0007h
	mov dh, 0
	mov dl, 0
	int 10h
Load1:
	mov ax, cs
	mov es, ax
	mov bx, Offset1
	mov ah, 2
	mov al, 1;扇区数量
	mov dl, 1;驱动器
	mov dh, 0;磁头
	mov ch, 0;柱头
	mov cl, 1;起始扇区号
	int 13h
	
	call Offset1
endRun:
	jmp $
	
msg1:
	db 'My-Os is loading user program 1.COM...'
msg1len equ ($-msg1)
	times 510-($-$$) db 0
	db 0x55,0xaa
	

	