;boot program  
  
BOOTSEG     equ 0x07c0  
DISPLAYSEG  equ 0xb800  
  
_start:  
  
    ;初始化数据段，使其指向段基址0X7C0处，即Boot代码被加载的地方  
    mov     ax, BOOTSEG  
    mov     ds, ax  
  
    ;将文本显示内存段基址 放在ES中，供后面显示字符使用  
    mov     ax, DISPLAYSEG  
    mov     es, ax  
  
    mov     cx, msglen  
    mov     si, message  
    xor     di, di  
  
print_str:  
  
    mov     al, [si]  
    mov     [es:di], al  
    inc   si  
    inc     di  
    mov byte    [es:di], 0x07  
    inc     di  
    loop    print_str  
  
    jmp near $      ;死循环，程序在此处终止  
  
  
    message     db "Loading System...", 13, 10  
    msglen      db $ - message  
  
    times 510-($-$$) db 0  
    dw  0xaa55  
	
	;from http://blog.csdn.net/sivolin/article/details/40859987