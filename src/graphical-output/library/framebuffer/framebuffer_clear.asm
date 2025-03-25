	;; take framebuffer address as start point
	;; add framebuffer memory size to that to get end point
	;; loop through every pixel (using 32 bits per pixel as the increment, which means we add 4 to address as referencing is in bytes) to set the screen to a standard colour


	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/system/syscalls.asm"


	push rsi
	push rdi
	push rax
	
	mov rsi, framebuffer

	mov dword [rsi], 0xFFFFFFFF ; this is setting up a pixel in the framebuffer memory at rsi

	mov rdi, 0x2		; file descriptor of framebuffer
	mov rax, __NR_write
	syscall

	pop rax
	pop rdi
	pop rsi

	ret

	
