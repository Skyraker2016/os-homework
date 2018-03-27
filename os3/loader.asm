[BITS 16]
global _start

_start:
	mov ax, cs
	mov ds, ax
clc_all:;清空屏幕
    mov al, 0
    mov ah, 6
    mov ch, 0
    mov cl, 0
    mov dh, 25
    mov dl, 80
    int 10h
load_os1:
    mov ax, cs
	mov es, ax
    mov bx, 0x1000
	mov ah, 2;功能号
	mov al, 18;扇区数量
	mov dl, 0;驱动器
	mov dh, 0;磁头
	mov ch, 0;柱头
	mov cl, 2;起始扇区号
    int 13h

;load_data:
;    mov ax, cs
;	mov es, ax
;    mov bx, 0x9000
;	mov ah, 2;功能号
;	mov al, 2;扇区数量
;	mov dl, 0;驱动器
;	mov dh, 0;磁头
;	mov ch, 0;柱头
;	mov cl, 17;起始扇区号
;   int 13h

    mov bx, 0x1000
    jmp bx

times (510-($-$$)) db 0
dw 0xAA55
