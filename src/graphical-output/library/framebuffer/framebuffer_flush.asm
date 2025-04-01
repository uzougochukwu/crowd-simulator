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
	movzx rdi, byte [framebuffer_file_descriptor]
	mov rsi, [framebuffer_address]
	mov rdx, [total_framebuffer_memory]
	syscall

	call error_handling	; defined in syscalls.asm

	;;  seek to byte 0 of the framebuffer
	mov rax, __NR_lseek
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
