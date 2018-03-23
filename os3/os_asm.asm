[BITS 16]

global _print_s,_set_gb,_print_A

_print_A:
    enter 0,0
    push bx
    push es
    push bp
    mov ax, 0xB800
    mov es, ax
    mov bx, 0
    mov al, [bp+6]
    mov ah, 0FH
    mov [es:0], ax
    pop bp
    pop es
    pop bx
    leave
    pop ecx
    jmp cx

_set_gb:
    push bx
    push dx

    mov bh, 0;页号
    mov dh, 0;行
    mov dl, 0;列
    mov ah, 2
    int 10H

    pop bx
    pop dx
    pop ecx
    jmp cx

_print_s:
    enter 0, 0
    push bx
    push cx
    push dx
    push bp
    push es

    mov cx, [bp+2+4*2]
    mov dh, [bp+2+4*3]
    mov dl, 0
    mov ax, cs
    mov es, ax
    mov bp, [bp+2+4*1]
    mov ah, 0x13
    mov al, 0
    mov bh, 0
    mov bl, 0FH
    int 10h

    pop es
    pop bp
    pop dx
    pop cx
    pop bx

    leave
    pop ecx
    jmp cx

