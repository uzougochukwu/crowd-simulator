;; queries the framebuffer to find out how much extra memory we need.
	; might change to have colour in rsi rather than rdi
	
	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/system/syscalls.asm"
	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/framebuffer/framebuffer_clear.asm"
	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/framebuffer/framebuffer_flush.asm"
        %include "/home/calebmox/crowd-simulator/src/graphical-output/library/system/error_handling.asm"
        %include "/home/calebmox/crowd-simulator/src/graphical-output/shapes/set_pixel.asm"
%include "/home/calebmox/crowd-simulator/src/graphical-output/shapes/set_line.asm"
%include "/home/calebmox/crowd-simulator/src/graphical-output/shapes/set_rect.asm"
	%include "/home/calebmox/crowd-simulator/src/graphical-output/shapes/set_filled_rect.asm"

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

	call framebuffer_clear ; framebuffer set to white



	mov rsi, 0x1FFF1C232	; line set to brown 

	mov rdi, [framebuffer_address]
	
	mov r8, 100		; x0
	mov r9, 200		; y0

	mov r10, 300		; x1
	mov r11, 100		; y1

	mov rdx, [x]		; rdx is x res, which is width
	mov rcx, [y]		; rcx is y res, which is height

	call set_filled_rect	

	call framebuffer_flush

	


	mov rax, __NR_exit
	mov rdi, 0x0
	syscall

	



	
