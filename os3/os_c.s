	.file	"os_c.c"
/APP
	.code16gcc

	mov $0, %eax

	mov %ax, %ds

	mov %ax, %es

	jmpl $0, $__main

/NO_APP
	.globl	wel_msg
	.section .rdata,"dr"
.LC0:
	.ascii "WELCOME TO MY_OS:\12\15\0"
	.data
	.align 8
wel_msg:
	.quad	.LC0
	.text
	.globl	_main
	.def	_main;	.scl	2;	.type	32;	.endef
	.seh_proc	_main
_main:
	pushq	%rbp
	.seh_pushreg	%rbp
	movq	%rsp, %rbp
	.seh_setframe	%rbp, 0
	subq	$32, %rsp
	.seh_stackalloc	32
	.seh_endprologue
	call	set_gb
	movq	wel_msg(%rip), %rax
	movq	%rax, %rcx
	call	print_s
	movl	$65, %ecx
	call	print_c
.L2:
	jmp	.L2
	.seh_endproc
	.globl	print_s
	.def	print_s;	.scl	2;	.type	32;	.endef
	.seh_proc	print_s
print_s:
	pushq	%rbp
	.seh_pushreg	%rbp
	movq	%rsp, %rbp
	.seh_setframe	%rbp, 0
	subq	$48, %rsp
	.seh_stackalloc	48
	.seh_endprologue
	movq	%rcx, 16(%rbp)
	movl	$0, -4(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L4
.L5:
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	16(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	movl	%eax, %ecx
	call	print_c
	addl	$1, -4(%rbp)
.L4:
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	16(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jne	.L5
	nop
	addq	$48, %rsp
	popq	%rbp
	ret
	.seh_endproc
	.ident	"GCC: (x86_64-posix-seh-rev1, Built by MinGW-W64 project) 7.2.0"
	.def	set_gb;	.scl	2;	.type	32;	.endef
	.def	print_c;	.scl	2;	.type	32;	.endef
