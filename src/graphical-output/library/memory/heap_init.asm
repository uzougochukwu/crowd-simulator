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

	mov rdi, 0x1FFFFFFFF 		; this is the colour that framebuffer_clear will set the screen to (cyan)  0x1FF00FFE5, black is 0x1FF000000

	call framebuffer_clear	

	call framebuffer_flush

	mov r8, 100
	mov r9, 200
	mov rsi, 0x1FF008C45

	mov rdi, [framebuffer_address]

	call set_pixel

	call framebuffer_flush


	mov rax, __NR_exit
	mov rdi, 0x0
	syscall

	



	
