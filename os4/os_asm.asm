[BITS 16]

global __printc, __getc, __uproll, __downroll, __load_program, __run_program, __set_gb, __clc, __screen_block, __get_gb, __check_in, __delay
global __printc_color, __getc_dontway, __get_date, __get_time, __reload, _init_int, _test_int
extern _int_08H_c, _int_09H_c,  _int_33H_c, _int_34H_c, _int_35H_c, _int_36H_c 
extern __prints, __show_time, __gets

_test_int:
    push bx
    int 33H
    int 34H
    int 35H
    int 36H
    mov ah, 1
    int 21H
    mov ah, 3
    int 21H
    mov ebx, eax
    mov ah, 4
    int 21H
    mov ah, 2
    int 21H
    pop bx
    pop ecx
    jmp cx

__reload:
    jmp 0FFFFH:0000H

__clc:
    mov al, 03h
    mov ah, 0
    int 10h
    pop ecx
    jmp cx

__screen_block:
    enter 0,0
    push bx
    push ds
    push es
    push bp
    
    mov ah, 06h
    mov al, 0
    mov bx, [bp+2+4*5]
    mov ch, [bp+2+4*1]
    mov cl, [bp+2+4*2]
    mov dh, [bp+2+4*3]
    mov dl, [bp+2+4*4]
    int 10H

    pop bp
    pop es
    pop ds
    pop bx
    leave
    pop ecx
    jmp cx

_init_int:
    push bx
    push es
    push ax
    cli
    mov bx, 0
    mov es, bx
    ;int 08H
    mov ax, [es:8*4]
    mov [old_08H], ax
    mov ax, [es:8*4+2]
    mov [old_08H+2], ax
    mov word[es:8*4], int_08H
    mov word[es:8*4+2], 0
    ;int 09H
    mov ax, [es:9*4]
    mov [old_09H], ax
    mov ax, [es:9*4+2]
    mov [old_09H+2], ax
    mov word[es:9*4], int_09H
    mov word[es:9*4+2], 0
    ;int 21H
    mov word[es:21H*4], int_21H
    mov word[es:21H*4+2], 0
    ;int 33H
    mov word[es:33H*4], int_33H
    mov word[es:33H*4+2], 0
    ;int 34H
    mov word[es:34H*4], int_34H
    mov word[es:34H*4+2], 0
    ;int 35H
    mov word[es:35H*4], int_35H
    mov word[es:35H*4+2], 0
    ;int 36H
    mov word[es:36H*4], int_36H
    mov word[es:36H*4+2], 0
    sti
    pop ax
    pop es
    pop bx
    pop ecx
    jmp cx

old_08H:
    dw 0, 0;

int_08H:
    push ax
    push bx
    push cx
    push dx
    push ds
    push es


    mov ax, cs
    mov ds, ax

    push 0
    call _int_08H_c
    pushf
    call far [old_08H]

    pop es
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
    iret

old_09H:
    dw 0, 0;

int_09H:
    push ax
    push bx
    push cx
    push dx
    push ds
    push es


    mov ax, cs
    mov ds, ax
    push 0

    call _int_09H_c
    pushf
    call far [old_09H]

    pop es
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
    iret  

int_21H:
    push ds
    push es
    cmp ah, 1
        jz int_21H_1;show time
    cmp ah, 2
        jz int_21H_2;get char
    cmp ah, 3
        jz int_21H_3;get string
    cmp ah, 4
        jz int_21H_4;print string, ebx is the point
int_21H_back:
    pop es
    pop ds
    iret
int_21H_1:
    push 0
    call __show_time
    jmp int_21H_back
int_21H_2:
    push 0
    call __getc
    jmp int_21H_back
int_21H_3:
    push 0
    call __gets
    jmp int_21H_back
int_21H_4:
    push ebx
    push 0
    call __prints
    pop ebx
    jmp int_21H_back

int_33H:
    push 0
    call _int_33H_c
    iret
int_34H:
    push 0
    call _int_34H_c
    iret
int_35H:
    push 0
    call _int_35H_c
    iret
int_36H:
    push 0
    call _int_36H_c
    iret

__get_date:
    enter 0, 0
    push bx
    push bp

    mov ah, 04h
    int 1ah
    push cx
    push dx
    pop eax

    pop bp
    pop bx
    leave
    pop ecx
    jmp cx


__get_time:
    enter 0, 0
    push bx
    push bp

    mov ah, 02h
    int 1ah
    push cx
    push dx
    pop eax

    pop bp
    pop bx
    leave
    pop ecx
    jmp cx
__set_gb:
    enter 0,0
    push bp
    push bx
    push cx
    push dx

    mov cl, 07h
    mov ch, 06h
    mov ah, 01h
    int 10h

    mov bh, 0
    mov dh, [bp+2+4*2]
    mov dl, [bp+2+4*1]
    mov ah, 02h
    int 10h

    pop dx
    pop cx
    pop bx
    pop bp
    leave
    pop ecx
    jmp cx

__get_gb:
    enter 0,0
    push bp
    push bx
    push cx
    push dx

    mov ah, 03h
    mov bh, 0
    int 10h
    mov eax, 0
    mov ax, dx

    pop dx
    pop cx
    pop bx
    pop bp
    leave
    pop ecx
    jmp cx

__printc:
    enter 0, 0
    
    push bp
    push bx
    push dx

    mov al, [bp+2+4*1]
    cmp al, 13
    jz _printc_a
    cmp al, 10
    jz _printc_a

    mov bh, 0
    mov al, ' '
    mov bl, 0x07
    mov cx, 1
    mov ah, 09h
    int 10h
_printc_a:
    mov al, [bp+2+4*1]
    mov bl, 0
    mov ah, 0eh
    int 10h

    pop dx
    pop bx
    pop bp
    leave
    pop ecx
    jmp cx

__printc_color:
    enter 0, 0
    
    push bp
    push bx

    mov bh, 0
    mov al, [bp+2+4*1]
    mov bl, [bp+2+4*2]
    mov cx, 1
    mov ah, 09h
    int 10h

    pop bx
    pop bp
    leave
    pop ecx
    jmp cx


__getc_dontway:
    enter 0,0

    push bp
    push bx
    cmp ah, ah
    mov ah, 11h
    int 16h
        jnz dontwait_t
    mov eax, 0
    dontwait_back:

    pop bx
    pop bp

    leave
    pop ecx
    jmp cx  
    dontwait_t:
        mov eax, 0
        mov ah, 10H
        int 16h
        jmp dontwait_back 

__getc:
    enter 0,0

    push bp
    push bx
    mov eax, 0
    mov ah, 10H
    int 16h
    pop bx
    pop bp

    leave
    pop ecx
    jmp cx


__uproll:
    enter 0,0
    
    push bp
    push bx
    push cx
    push dx

    mov al, [bp+6]
    mov bh, 0FH
    mov ch, 0
    mov cl, 0
    mov dh, 24
    mov dl, 79
    mov ah, 07h
    int 10h

    pop dx
    pop cx
    pop bx
    pop bp

    leave
    pop ecx
    jmp cx

__downroll:
    enter 0,0
    
    push bp
    push bx
    push cx
    push dx

    mov al, [bp+6]
    mov bh, 0FH
    mov ch, 0
    mov cl, 0
    mov dh, 24
    mov dl, 79
    mov ah, 06h
    int 10h

    pop dx
    pop cx
    pop bx
    pop bp

    leave
    pop ecx
    jmp cx

__delay:
    enter 0,0

    push bx
    push cx
    push dx
    push bp

    mov cx, [bp+6]
    _delay_loop:
    mov ax, 200
    _delay_loop_a:
    mov bx, 500
    _delay_loop_b:
    dec bx
        jnz _delay_loop_b
        dec ax
            jnz _delay_loop_a
    loop _delay_loop

    pop bp
    pop dx
    pop cx
    pop bx

    leave
    pop ecx
    jmp cx

__check_in:
    enter 0,0

    push bp
    push bx
    cmp ah, ah
    mov ah, 01h
    int 16h
        jnz _check_in_t
    mov eax, 0
    _check_in_back:

    pop bx
    pop bp

    leave
    pop ecx
    jmp cx  
    _check_in_t:
        mov eax, 0
        mov ax, 1 
        push eax
        mov ah, 0
        int 16h
        pop eax
        jmp _check_in_back 

__load_program:
    enter 0,0

    push es
    push bx
    push dx
    push cx

    mov ax, [bp+2+4*6]
	mov es, ax
    mov bx, [bp+2+4*5]
	mov ah, 2;功能号
	mov al, [bp+2+4*4];扇区数量
	mov dl, 0;驱动器
	mov dh, [bp+2+4*1];磁头
	mov ch, [bp+2+4*3];柱面
	mov cl, [bp+2+4*2];起始扇区号
    int 13h

    pop cx
    pop dx
    pop bx
    pop es

    leave
    pop ecx
    jmp cx

__run_program:
    enter 0,0

    mov ax, [bp+2+4*1]
    mov [_far_call_add+2], ax
    mov ax, [bp+2+4*2]
    mov [_far_call_add], ax
    mov ax, 0
    push ax
    push cs
    call far [_far_call_add]


    leave
    pop ecx
    jmp cx
_far_call_add dw 0, 0