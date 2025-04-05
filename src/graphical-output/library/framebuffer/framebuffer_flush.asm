	;;  push image to the framebuffer


	%ifndef FRAMEBUFFER_FLUSH
	%define FRAMEBUFFER_FLUSH

	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/framebuffer/framebuffer_info.asm"
%include "/home/calebmox/crowd-simulator/src/graphical-output/library/system/syscalls.asm"

	section .text
	global framebuffer_flush


framebuffer_flush:

	push rdi
	push rsi
	push rdx
	push rax


	;; write frame onto the framebuffer
	mov rax, __NR_write
	movzx rdi, byte [framebuffer_file_descriptor] ; this zero extends the number, as the upper 7 bytes of rdi may already contain a number
	mov rsi, [framebuffer_address]		      ; the initial address of the area in memory that we have decided should represent the framebuffer is moved into rsi 
	mov rdx, [total_framebuffer_memory]	      ; total_framebuffer_memory is moved into rdx, which tells the kernel how much memory to write to the framebuffer 
	syscall

	call error_handling	; defined in syscalls.asm

	;;  seek to byte 0 of the framebuffer
	mov rax, __NR_lseek	; so that when we flush to the framebuffer again, we can start from the first pixel
	movzx rdi, byte [framebuffer_file_descriptor]
	xor rsi, rsi
	mov rdx, seek_set
	syscall

	call error_handling

	pop rax
	pop rdx
	pop rsi
	pop rdi

	ret


	%endif
