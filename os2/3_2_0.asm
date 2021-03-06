org 7c00h
load_offset equ 7100h;基础加载位置，实际加载位置为7100H+1000H*编号

start:
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
say_welcome:;引导语
    call clc_head
    mov bp, welcome
	mov cx, welcomeL
    call saying
check_users_input:;
    mov ah, 0
    int 16h
    cmp al, '1'
        jz load_program
    cmp al, '2'
        jz load_program
    cmp al, '3'
        jz load_program
    cmp al, '4'
        jz load_program
    cmp al, 'a'
        jz reset_load
    cmp al, 'b'
        jz reset_load
    cmp al, 'c'
        jz reset_load
    cmp al, 'd'
        jz reset_load
    cmp al, '0'
        jz clc_all
    jmp wrong_input
load_program:
    sub al, '0'
    mov [index], al
    call count_where
    mov al, [index]
    call count_origin
    cmp ax, [di];若未加载，则重新加载
        jz pre_reset_load
    mov ax, [di]
    mov [programT], ax
    jmp load_success


pre_reset_load:
    mov al, [index]
    add al, 96;1->a
reset_load:
    sub al, 96
    mov [index], al
    call count_origin
    mov bx, ax
    mov [programT], ax
    mov ax, cs
	mov es, ax
	mov ah, 2
	mov al, 2;扇区数量
	mov dl, 0;驱动器
	mov dh, 0;磁头
	mov ch, 0;柱头
	mov cl, [index];起始扇区号
    add cl, [index]
	int 13h
load_success:
    call clc_head
    mov bp, success_msg
    mov cx, success_msgL
    call saying
    mov al, [index]
    add al, '0'
    mov bl, 0EH
    mov ah, 0EH
    int 10h
    call [programT]
;write_back:
;    mov ax, cs
;    mov es, ax
;    mov ah, 3
;    mov al, 2
;    mov dl, 0
;    mov ch, 0
;    mov dh, 0
;    mov cl, [index]
;    add cl, [index]
;    mov bx, load_offset
;    int 13h
;back
    mov al, [index]
    call count_where
    mov [di], dx
jmp say_welcome
jmp $



wrong_input:
    call clc_head
    mov bp, wrong_msg
	mov cx, wrong_msgL
    call saying
    jmp check_users_input

clc_head:
    mov bp, clc_msg
    mov cx, clc_msgL
    call saying
    ret

saying:
    ;mov bp, wrong_msg
	mov ax, ds
	mov es, ax
	;mov cx, wrong_msgL
	mov ax, 1301h
	mov bx, 000Eh
	mov dh, 0
	mov dl, 0
	int 10h
    ret

count_where:
    add al, al
    mov ah, 0
    add ax, programT
    mov di, ax
    ret

count_origin:
    mov ah, 0
    mov bx, 1000h
    mul bx
    add ax, load_offset
    ret


welcome:
    db 'Hello, please choose witch program you want to load in: '
welcomeL equ ($-welcome)
wrong_msg:
    db 'Hey! Your input was wrong! Please try to choose again: '
wrong_msgL equ ($-wrong_msg)
success_msg:
    db '                              Program '
success_msgL equ ($-success_msg)
clc_msg:
    db '                                                                                '
clc_msgL equ($-clc_msg)
index db 0
programT dw 0
programA dw 0x8100
programB dw 0x9100
programC dw 0xA100
programD dw 0xB100
times 510-($-$$) db 0
dw 0xaa55
;7dd0 7c5a 7ca2