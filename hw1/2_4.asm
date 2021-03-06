;显示学号姓名缩写
	DRt equ 1                  	;D-Down,U-Up,R-right,L-Left
    URt equ 2                  	;
    ULt equ 3                  	;
    DLt equ 4                  	;
    delay equ 50000				;计时器延迟计数,用于控制画框的速度
    ddelay equ 580		 		;延迟580*50000次
	Hm equ 25					;最大高度
	Lm equ 80  					;最大宽度
	len equ 14					;字符串长度
	
	BOOTSEG equ 0x7c00  		;段基址0x7c00
	DISPLAYSEG equ 0xb800  		;显存及地址0xb800
	org BOOTSEG					;告诉汇编器要在0x7c00执行
	
section .text
_start:  
  
    ;初始化数据段，使其指向0X7C00处，即Boot代码被加载的地方  
    mov     ax, cs
    mov     ds, ax  
	
    ;将文本显示内存段基址 放在ES中，供后面显示字符使用  
    mov     ax, DISPLAYSEG  
    mov     es, ax  
	
loop1:
	dec word[count]				; 递减计数变量
		jnz loop1					; >0：跳转;
		mov word[count],delay
	dec word[dcount]				; 递减计数变量
		jnz loop1
		mov word[count],delay
		mov word[dcount],ddelay
	;mov al, 20H	;空格覆盖
	;mov ah, 0FH	
	;mov [es:bx], ax   
	dec byte[color]
	cmp byte[color], 01H
	jz reset
back:
	mov al, DRt	;↘
		cmp al, byte[dir]
		jz DRF
	mov al, DLt	;↙
		cmp al, byte[dir]
		jz DLF
	mov al, URt	;↗
		cmp al, byte[dir]
		jz URF
	mov al, ULt	;↖
		cmp al, byte[dir]
		jz ULF
	jmp $

DRF:
	inc word[x]	
	inc word[y]	;向右下前进一格
	mov ax, Hm
		mov bx, word[x]	;判断x是否越界
		cmp ax, bx
		jz dr2ur
	mov ax, Lm-len
		mov bx, word[y]	;判断y是否越界
		cmp ax, bx
		jz dr2dl
	jmp display
dr2ur:	;回弹——从右下改为右上
	mov word[x], Hm-2
	mov ax, Lm-len	;判断是否为角落
		mov bx, word[y]
		cmp ax, bx
		jz drA
	mov byte[dir], URt
	
	jmp display
dr2dl:
	mov word[y], Lm-len-2
	mov byte[dir], DLt
	
	jmp display
drA:	;角落时原路返回
	mov word[y],Lm-len-2
	mov byte[dir], ULt
	
	jmp display
	
DLF:
	inc word[x]
	dec word[y]
	mov ax, Hm
		mov bx, word[x]
		cmp ax, bx
		jz dl2ul
	mov ax, -1
		mov bx, word[y]
		cmp ax, bx
		jz dl2dr
	jmp display
dl2ul:
	mov word[x], Hm-2
	mov ax, -1
		mov bx, word[y]
		cmp ax, bx
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
		cmp ax, bx
		jz ur2dr
	mov ax, Lm-len
		mov bx, word[y]
		cmp ax, bx
		jz ur2ul
	jmp display
ur2dr:
	mov word[x], 1
	mov ax, Lm-len
		mov bx, word[y]
		cmp ax, bx
		jz urA
	mov byte[dir], DRt
	
	jmp display
ur2ul:
	mov word[y], Lm-len-2
	mov byte[dir], ULt
	
	jmp display
urA:
	mov word[y], Lm-len-2
	mov byte[dir], DLt
	
	jmp display
	
ULF:
	dec word[x]
	dec word[y]
	mov ax, -1
		mov bx, word[x]
		cmp ax, bx
		jz ul2dl
	mov ax, -1
		mov bx, word[y]
		cmp ax, bx
		jz ul2ur
	jmp display
ul2dl:
	mov word[x], 1
	mov ax, -1
		mov bx, word[y]
		cmp ax, bx
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
	
display:	;显示模块
	mov ax, word[x]
	mov bx, Lm
	mul bx
	add ax, word[y]
	mov bx, 2
	mul bx
	mov bx, ax	;bx = ax = (x*80+y) * 2
	mov cx, len
	mov si, info
	mov ah, [color]
loop_str:
	mov al, [si]
	mov [es:bx], ax
	inc si
	inc bx
	inc bx
	loop loop_str
	
	jmp loop1

reset:
	mov byte[color], 0FH
	jmp back
end:
	jmp $

;section .data
	
	info db " ygz 16337287 ",0
    count dw delay
    dcount dw ddelay
    dir db DRt         ; 向右下运动
    x    dw 2
    y    dw 0
	color db 0FH
	
    times 510-($-$$) db 0  ;填充空格
    dw  0xaa55  