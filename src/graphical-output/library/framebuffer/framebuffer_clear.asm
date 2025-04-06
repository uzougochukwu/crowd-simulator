	;; take framebuffer address as start point
	;; add framebuffer memory size to that to get end point
	;; loop through every pixel (using 32 bits per pixel as the increment, which means we add 4 to address as referencing is in bytes) to set the screen to a standard colour

	;; have rsi as the start address, move rsi into rcx and add total framebuffer memory/8 (to convert from bits to bytes) to it
	;;  rcx is now the end address
	;;  now loop from address in rsi to address in rcx
	;;  rdi contains colour
	;;  may need to have separate framebuffer address
	;; the first memory address found by the first brk syscall in heap_init may be the framebuffer address, we then calculate framebuffer size as normal
	;; when we write to the framebufffer, we modify a separate memory address and then we write to the actual framebuffer
	;; investigate value in total_framebuffer_memory
	;;  now create the framebuffer_flush

	;;  sets the framebuffer to be 32 bit alpha-red-green-blue colour defined in rdi 
	%ifndef FRAMEBUFFER_CLEAR
	%define FRAMEBUFFER_CLEAR

	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/system/syscalls.asm"
	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/framebuffer/framebuffer_info.asm"

framebuffer_clear:	

	push rsi
	push rcx

	
	mov rsi, [framebuffer_address]

	mov rcx, [total_framebuffer_memory]

	shr rcx, 2		;  might try dividing by 4 to fill screen

loop:
	
	mov dword [rsi], edi ; this is setting up a pixel in the framebuffer memory at rsi

	add rsi, 4
	dec rcx

	jnz loop


	pop rcx
	pop rsi

	ret

	
%endif
