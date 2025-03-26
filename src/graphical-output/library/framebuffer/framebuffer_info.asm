	;; push all the registers that are modified in this routine onto the stack and pop them at the end
	;; remove the _start symbol and put ret at the end
	;; this script should be included in the heap_init script
	;; need to establish which register (if any) contains overall memory requirement
	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/system/syscalls.asm"

section .data
	
framebuffer: db `/dev/fb0\0`

section .bss
framebuffer_info: resb 1280 
x:	resb 10
y:	resb 10
bits_per_pixel:	 resb 10
total_framebuffer_memory: resb 10
framebuffer_address:	resb 10

	
	section .text
	global query_framebuffer

query_framebuffer:	

	push rax
	push rdi
	push rsi
	push rdx
	push r8
	push r10
	push r11


	
	mov rax, __NR_open	; get file descriptor of framebuffer
	mov rdi, framebuffer
	mov rsi, o_wronly
	syscall

	mov rdi, rax		; move file descriptor into rdi
	mov rsi, fbioget_vscreeninfo
	mov rdx, framebuffer_info
	mov rax, __NR_ioctl
	syscall

	mov r8d, dword [framebuffer_info] ; each number in frame buffer info location is 32 bit, so we need 32 bit register
	mov dword [x], r8d

	mov r8d, dword [framebuffer_info + 4]
	mov dword [y], r8d

	mov r8d, dword [framebuffer_info + 24]
	mov dword [bits_per_pixel], r8d

	mov r10d, [x]
	mov r11d, [y]

	imul r8, r11		; bits_per_pixel * y
	imul r8, r10		; (bits_per_pixel * y) * x
	;; r8 contains total number of bits needed for framebuffer

	mov qword [total_framebuffer_memory], r8



	pop r11
	pop r10
	pop r8
	pop rdx
	pop rsi
	pop rdi
	pop rax

	ret

	

	
