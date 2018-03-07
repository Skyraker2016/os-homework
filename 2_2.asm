;线显示
	DRt equ 1                  ;D-Down,U-Up,R-right,L-Left
    URt equ 2                  ;
    ULt equ 3                  ;
    DLt equ 4                  ;
    delay equ 50000				; 计时器延迟计数,用于控制画框的速度
    ddelay equ 580		 
	Hm equ 25
	Lm equ 80
	org 100h					; 程序加载到100h，可用于生成COM

section .data
	char db 'A'
    count dw delay
    dcount dw ddelay
    dir db DRt         ; 向右下运动
    x    dw 7
    y    dw 0

	

section .text
begin:
	mov ax, 0B800H
	mov es, ax
	mov byte[char], 'A'
	mov word[count], delay
	mov word[dcount], ddelay
	mov byte[dir], DRt
	mov word[x], 7
	mov word[y], 0
	
loop1:
	dec word[count]				; 递减计数变量
		jnz loop1					; >0：跳转;
		mov word[count],delay
	dec word[dcount]				; 递减计数变量
		jnz loop1
		mov word[count],delay
		mov word[dcount],ddelay
	;mov al, 20H
	;mov [es:bx], ax
	mov al, DRt
		cmp al, byte[dir]
		jz DRF
	mov al, DLt
		cmp al, byte[dir]
		jz DLF
	mov al, URt
		cmp al, byte[dir]
		jz URF
	mov al, ULt
		cmp al, byte[dir]
		jz ULF
		
	jmp $

DRF:
	inc word[x]
	inc word[y]
	mov ax, Hm
		mov bx, word[x]
		sub ax, bx
		jz dr2ur
	mov ax, Lm
		mov bx, word[y]
		sub ax, bx
		jz dr2dl
	jmp display
dr2ur:
	mov word[x], Hm-2
	mov ax, Lm
		mov bx, word[y]
		sub ax, bx
		jz drA
	mov byte[dir], URt
	jmp display
dr2dl:
	mov word[y], Lm-2
	mov byte[dir], DLt
	jmp display
drA:
	mov word[y],Lm-2
	mov byte[dir], ULt
	jmp display
	
DLF:
	inc word[x]
	dec word[y]
	mov ax, Hm
		mov bx, word[x]
		sub ax, bx
		jz dl2ul
	mov ax, -1
		mov bx, word[y]
		sub ax, bx
		jz dl2dr
	jmp display
dl2ul:
	mov word[x], Hm-2
	mov ax, -1
		mov bx, word[y]
		sub ax, bx
		jz dlA	
	mov byte[dir], ULt
	jmp display
dl2dr:
	mov word[y], 1
	mov byte[dir], DRt
	jmp display
dlA:
	mov word[y], 1
	mov byte[dir], URt
	jmp display
	
URF:
	dec word[x]
	inc word[y]
	mov ax, -1
		mov bx, word[x]
		sub ax, bx
		jz ur2dr
	mov ax, Lm
		mov bx, word[y]
		sub ax, bx
		jz ur2ul
	jmp display
ur2dr:
	mov word[x], 1
	mov ax, Lm
		mov bx, word[y]
		sub ax, bx
		jz urA
	mov byte[dir], DRt
	jmp display
ur2ul:
	mov word[y], Lm-2
	mov byte[dir], ULt
	jmp display
urA:
	mov word[y], Lm-2
	mov byte[dir], DLt
	jmp display
	
ULF:
	dec word[x]
	dec word[y]
	mov ax, -1
		mov bx, word[x]
		sub ax, bx
		jz ul2dl
	mov ax, -1
		mov bx, word[y]
		sub ax, bx
		jz ul2ur
	jmp display
ul2dl:
	mov word[x], 1
	mov ax, -1
		mov bx, word[y]
		sub ax, bx
		jz ulA	
	mov byte[dir], DLt
	jmp display
ul2ur:
	mov word[y], 1
	mov byte[dir], URt
	jmp display
ulA:
	mov word[y], 1
	mov byte[dir], DRt
	jmp display
	
display:
	mov ax, word[x]
	mov bx, Lm
	mul bx
	add ax, word[y]
	mov bx, 2
	mul bx
	mov bx, ax
	mov ah, 0FH
	mov al, byte[char]
	mov [es:bx], ax
	jmp loop1
	
end:
	jmp $
	