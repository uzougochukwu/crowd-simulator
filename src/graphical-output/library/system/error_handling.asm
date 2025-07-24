
	%ifndef ERROR_HANDLING
	%define ERROR_HANDLING

	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/system/syscalls.asm"

	section .text
	global error_handling

error_handling:

	cmp rax, 0x0
	jl next_exit

	ret

next_exit:

	mov rax, __NR_execve
	
	mov rsi, argv_array
	mov rdx, 0
	syscall

	mov rax, __NR_exit
	syscall



	%endif
