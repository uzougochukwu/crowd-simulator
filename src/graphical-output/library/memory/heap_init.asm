;; queries the framebuffer to find out how much extra memory we need.
	; might change to have colour in rsi rather than rdi
	
	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/system/syscalls.asm"
	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/framebuffer/framebuffer_clear.asm"
	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/framebuffer/framebuffer_flush.asm"
        %include "/home/calebmox/crowd-simulator/src/graphical-output/library/system/error_handling.asm"
	%include "/home/calebmox/crowd-simulator/src/graphical-output/shapes/set_pixel.asm"

	section .bss

brk_firstlocation:	 resq 1

	
	section .text
	global _start


_start:
	mov rax, __NR_brk
	syscall

	call error_handling 	; defined in syscalls.asm

	mov qword [brk_firstlocation], rax
	
	mov rdi, rax
	call query_framebuffer

	mov rax, [total_framebuffer_memory]


	add rdi, rax			;add framebuffer memory size to rdi so that address break is increased	

	
	
	mov rax, __NR_brk
	syscall

	call error_handling

	mov rdi, 0x1FFFFFFFF 		; colour set to white

	call framebuffer_clear	


	mov r8, 100
	mov r9, 200
	mov rsi, 0x1FFF1C232

	mov rdi, [framebuffer_address]
	
	call set_pixel


	mov r8, 101
	mov r9, 201


	call set_pixel


	mov r8, 102
	mov r9, 202

	call set_pixel



	mov r8, 103
	mov r9, 203


	call set_pixel

	call framebuffer_flush

	


	mov rax, __NR_exit
	mov rdi, 0x0
	syscall

	



	
