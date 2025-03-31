	;; will move the instruction pointer value into rdi, so that the user can see it as an exit code


	%ifndef ERROR_HANDLING
	%define ERROR_HANDLING

	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/system/syscalls.asm"

	section .bss

instruction_pointer:	resb 64

	section .text
	global error_handling

error_handling:

	

	mov rdi, [instruction_pointer]
	mov rax, __NR_exit
	syscall



	%endif
