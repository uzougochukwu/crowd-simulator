
	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/system/syscalls.asm"
	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/framebuffer/framebuffer_clear.asm"
	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/framebuffer/framebuffer_flush.asm"
	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/system/error_handling.asm"

	section .bss

brk_firstlocation:	 resq 1

	
	section .text
	global _start


_start:
	mov rax, __NR_brk
	syscall

	cmp rax, 0x0		; error handling
	jge first_next

	lea rcx, [_start]	; error handling - load address of _start label to rcx

	mov qword [instruction_pointer], rcx ; error handling - move the address of the start label to the instruction_pointer memory location, in the error handling file

	call error_handling

first_next:	

	mov qword [brk_firstlocation], rax
	
	mov rdi, rax
	call query_framebuffer

	mov rax, [total_framebuffer_memory]


	add rdi, rax			;add framebuffer memory size to rdi so that address break is increased	

second_brk_label:	
	
	mov rax, __NR_brk
	syscall

	cmp rax, 0x0		; error handling
	jge second_next

	lea rcx, [second_brk_label]	; error handling - load address of _start label to rcx

	mov qword [instruction_pointer], rcx ; error handling - move the address of the start label to the instruction_pointer memory location, in the error handling file

	call error_handling

second_next:	
	

	mov rdi, 0x1FF00FFE5		; this is the colour that framebuffer_clear will set the screen to (cyan)

	call framebuffer_clear	;; add framebuffer clear here


	mov rdi, [framebuffer_address]

	call framebuffer_flush	;;  add framebuffer flush here
	
	mov rax, __NR_exit
	mov rdi, 0x0
	syscall



	
