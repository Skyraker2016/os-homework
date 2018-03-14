;有规迹显示
	DRt equ 1                  ;D-Down,U-Up,R-right,L-Left
    URt equ 2                  ;
    ULt equ 3                  ;
    DLt equ 4                  ;
    delay equ 50000				; 计时器延迟计数,用于控制画框的速度
    ddelay equ 58		 
	Hm equ 25					;最大高度
	Lm equ 80  					;最大宽度
    LBond equ 40
    RBond equ 80
    UBond equ 13
    DBond equ 25

	DISPLAYSEG equ 0xb800  		;显存基地址0xb800
	org 0x8100

_start:  
  
    ;初始化数据段，使其指向段基址0X7C00处，即Boot代码被加载的地方  
    mov     ax, cs
    mov     ds, ax  
	
	clc_all:
    mov al, 0
    mov ah, 6
    mov ch, 13
    mov cl, 40
    mov dh, 25
    mov dl, 80
    int 10h  
	
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
	;判断是否输入
    mov ah, 1
    int 16h
        jnz end_program

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
	mov ax, DBond
		mov bx, word[x]	;判断x是否越界
		cmp ax, bx
		jz dr2ur
	mov ax, RBond
		mov bx, word[y]	;判断y是否越界
		cmp ax, bx
		jz dr2dl
	jmp display
dr2ur:	;回弹——从右下改为右上
	mov word[x], DBond-2
	mov ax, RBond	;判断是否为角落
		mov bx, word[y]
		cmp ax, bx
		jz drA
	mov byte[dir], URt
	
	jmp display
dr2dl:
	mov word[y], RBond-2
	mov byte[dir], DLt
	
	jmp display
drA:	;角落时原路返回
	mov word[y],RBond-2
	mov byte[dir], ULt
	
	jmp display
	
DLF:
	inc word[x]
	dec word[y]
	mov ax, DBond
		mov bx, word[x]
		cmp ax, bx
		jz dl2ul
	mov ax, LBond
		mov bx, word[y]
		cmp ax, bx
		jz dl2dr
	jmp display
dl2ul:
	mov word[x], DBond-2
	mov ax, LBond
		mov bx, word[y]
		cmp ax, bx
		jz dlA	
	mov byte[dir], ULt
	
	jmp display
dl2dr:
	mov word[y], LBond+2
	mov byte[dir], DRt
	
	jmp display
dlA:
	mov word[y], LBond+2
	mov byte[dir], URt
	
	jmp display
	
URF:
	dec word[x]
	inc word[y]
	mov ax, UBond
		mov bx, word[x]
		cmp ax, bx
		jz ur2dr
	mov ax, RBond
		mov bx, word[y]
		cmp ax, bx
		jz ur2ul
	jmp display
ur2dr:
	mov word[x], UBond+2
	mov ax, RBond
		mov bx, word[y]
		cmp ax, bx
		jz urA
	mov byte[dir], DRt
	
	jmp display
ur2ul:
	mov word[y], RBond-2
	mov byte[dir], ULt
	
	jmp display
urA:
	mov word[y], RBond-2
	mov byte[dir], DLt
	
	jmp display
	
ULF:
	dec word[x]
	dec word[y]
	mov ax, UBond
		mov bx, word[x]
		cmp ax, bx
		jz ul2dl
	mov ax, LBond
		mov bx, word[y]
		cmp ax, bx
		jz ul2ur
	jmp display
ul2dl:
	mov word[x], UBond+2
	mov ax, LBond
		mov bx, word[y]
		cmp ax, bx
		jz ulA	
	mov byte[dir], DLt
	
	jmp display
ul2ur:
	mov word[y], LBond+2
	mov byte[dir], URt
	
	jmp display
ulA:
	mov word[y], LBond+2
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
	mov ah, 0FH
	mov al, byte[char]
	mov [es:bx], ax	;写入显存
	jmp loop1
	
end_program:
    mov ah,0
    int 16h
	ret

section .data  
	char db 'A'
    count dw delay
    dcount dw ddelay
    dir db DRt         ; 向右下运动
	dir1 db DLt
    x    dw 21
    y    dw 40

    times 1024-($-$$) db 0  ;填充空格