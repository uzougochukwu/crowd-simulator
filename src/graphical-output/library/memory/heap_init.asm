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

section .data

rectangles: dw 400, 450, 900, 950 
	
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

	mov rdx, [x]		; rdx is x res, which is width
	mov rcx, [y]		; rcx is y res, which is height

	; maximum y coord is y res, usually 1080
	; maximum x coord is x res, usually 1920
	; if you go out of the top left corner or bottom right corner
        ; (framebuffer memory start and finish) you segfault
	; if you go out the top or the bottom of the screen, you segfault

before_draw:
	
	mov r8w, word [rectangles]		; x0 400
	mov r9w, word [rectangles + 2]		; y0 450

	mov r10w, word [rectangles + 4]		; x1 900
	mov r11w, word [rectangles + 6]		; y1 950


	call set_filled_rect	

	call framebuffer_flush


	mov r15, 1000

graphical_process:

	
	mov rdi, 0x1FFFFFFFF 		; colour set to white

	call framebuffer_clear ; framebuffer set to white

	mov rdi, [framebuffer_address]


	call set_filled_rect	

	call framebuffer_flush

	inc r8			; increment x0 and x1 so the rectangle moves to the right
	inc r10

	dec r15

	cmp r15, 0
	jne graphical_process

	mov rax, __NR_exit
	mov rdi, 0x0
	syscall

	



	
