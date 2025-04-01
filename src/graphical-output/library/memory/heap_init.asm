
	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/system/syscalls.asm"
	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/framebuffer/framebuffer_clear.asm"
	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/framebuffer/framebuffer_flush.asm"
	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/system/error_handling.asm"

%ifndef error_check
	
%macro error_check 2	; the first parameter is the next label in the program, the second parameter is the previous label

	cmp rax, 0x0		; if the value in rax is less than 0, then the system call resulted in an error
	jge %1			; if rax is greater than or equal to 0 then jump to the next label

	lea rcx, [%2]		; load the address of the previous label into rcx

	mov qword [instruction_pointer], rcx ; move the address of the previous label to the instruction_pointer memory location, in the error handling file

	call error handling
%endmacro
%endif

	section .bss

brk_firstlocation:	 resq 1

	
	section .text
	global _start


_start:
	mov rax, __NR_brk
	syscall

	error_check first_next, _start ; error_check macro defined in syscalls.asm

first_next:	

	mov qword [brk_firstlocation], rax
	
	mov rdi, rax
	call query_framebuffer

	mov rax, [total_framebuffer_memory]


	add rdi, rax			;add framebuffer memory size to rdi so that address break is increased	

second_brk_label:	
	
	mov rax, __NR_brk
	syscall

	error_check second_next, second_brk_label

second_next:	
	

	mov rdi, 0x1FF00FFE5		; this is the colour that framebuffer_clear will set the screen to (cyan)

	call framebuffer_clear	;; add framebuffer clear here


	mov rdi, [framebuffer_address]

	call framebuffer_flush	;;  add framebuffer flush here
	
	mov rax, __NR_exit
	mov rdi, 0x0
	syscall



	
