
	%include "/home/calebmox/graphical-output/library/system/syscalls.asm"
	
	section .text
	global _start

_start:
	mov rdi, 1
	mov rax, __NR_exit
	syscall
