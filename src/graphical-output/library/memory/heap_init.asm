
	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/system/syscalls.asm"
	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/framebuffer/framebuffer_clear.asm"
	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/framebuffer/framebuffer_flush.asm"


	section .bss

brk_firstlocation:	 resq 1

	
	section .text
	global _start


_start:
	mov rax, __NR_brk
	syscall

	mov qword [brk_firstlocation], rax
	
	mov rdi, rax
	call query_framebuffer

	mov rax, [total_framebuffer_memory]


	add rdi, rax			;add framebuffer memory size to rdi so that address break is increased	
	
	mov rax, __NR_brk
	syscall

	mov rdi, 0x1FF00FFE5		; this is the colour that framebuffer_clear will set the screen to (cyan)

	call framebuffer_clear	;; add framebuffer clear here


	mov rdi, [framebuffer_address]

	call framebuffer_flush	;;  add framebuffer flush here
	
	mov rax, __NR_exit
	mov rdi, 0x0
	syscall



	
