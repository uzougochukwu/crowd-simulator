
	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/system/syscalls.asm"
	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/framebuffer/framebuffer_clear.asm"


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

	xor rdi, rdi		; this is the colour that framebuffer_clear will set the screen to

	;; add framebuffer clear here

	mov rdi, [framebuffer]

	;;  add framebuffer flush here
	
	mov rax, __NR_exit
	syscall



	
