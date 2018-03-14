;显示学号姓名缩写
	DRt equ 1                  	;D-Down,U-Up,R-right,L-Left
    URt equ 2                  	;
    ULt equ 3                  	;
    DLt equ 4                  	;
    delay equ 50000				;计时器延迟计数,用于控制画框的速度
    ddelay equ 100		 		;延迟580*50000次
	Hm equ 25					;最大高度
	Lm equ 80  					;最大宽度
	LBond equ 40
    RBond equ 80
    UBond equ 1
    DBond equ 13

	DISPLAYSEG equ 0xb800  		;显存及地址0xb800
	org 0x8100					;告诉汇编器要在0x7c00执行
	
start:  
  
    ;初始化数据段，使其指向0X7C00处，即Boot代码被加载的地方  
    mov     ax, cs
    mov     ds, ax  

	clc_all:
    mov al, 0
    mov ah, 6
    mov ch, 1
    mov cl, 40
    mov dh, 13
    mov dl, 80
    int 10h  
    ;将文本显示内存段基址 放在ES中，供后面显示字符使用  
    mov     ax, DISPLAYSEG  
    mov     es, ax  
	mov 	si, info
	
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
    ;判断是否输入
    mov ah, 1
    int 16h
        jnz end_program

	mov ax, word[x]
	mov bx, Lm
	mul bx
	add ax, word[y]
	mov bx, 2
	mul bx
	mov bx, ax	;bx = ax = (x*80+y) * 2
	mov ah, [color]

	;mov al, byte[char]
	;信息输出：选择信息字符存入al：
	cmp byte[si], 0	;若到结尾重置
		jz reset
back:
	mov al, [si]
	mov [es:bx], ax	;写入显存
    inc si
	jmp loop1

reset:
	mov si, info
	;修改颜色
	dec ah
	jz color_reset
color_back:
	mov [color], ah
	jmp back
color_reset:
	mov ah, 0FH
	jmp color_back
	
end_program:
    mov ah,0
    int 16h
	ret

;section .data
  
	indx db 0
	info db "ygz16337287",0
    count dw delay
    dcount dw ddelay
    dir db DRt         ; 向右下运动
    x    dw 7
    y    dw 40
	color db 0FH
    times 1024-($-$$) db 0  ;填充空格
