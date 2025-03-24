
	%include "/home/calebmox/graphical-output/library/system/syscalls.asm"


	section .bss

brk_firstlocation:	 resq 1

	
	section .text
	global _start


_start:
	mov rax, __NR_brk
	syscall
	
	mov rdi, rax
	add rdi, 4096			;add 5 bytes to the first address 	
	
	mov rax, __NR_brk
	syscall

	mov rax, __NR_exit
	syscall



	
