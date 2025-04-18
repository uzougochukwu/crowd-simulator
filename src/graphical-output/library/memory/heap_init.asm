;; queries the framebuffer to find out how much extra memory we need.
	; might change to have colour in rsi rather than rdi
%ifndef HEAP_INIT
%define HEAP_INIT
	
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

line_colour: resd 1
	

section .data

rectangles: dw 160, 170, 200, 200, 160, 520, 200, 550, 160,700 ,200,730

lines: dw 0, 150, 50,160, 0, 180 , 50, 190, 0,220 , 200,230 
	
	section .text



heap_init:
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

	mov rdi, 0x1FF4faf25 		; colour set to green

	call framebuffer_clear ; framebuffer set to green



	mov rsi, 0x1FFF1C232	; line set to brown 

	mov rdi, [framebuffer_address]

	mov rdx, [x]		; rdx is x res, which is width
	mov rcx, [y]		; rcx is y res, which is height

	; maximum y coord is y res, usually 1080
	; maximum x coord is x res, usually 1920
	; if you go out of the top left corner or bottom right corner
        ; (framebuffer memory start and finish) you segfault
	; if you go out the top or the bottom of the screen, you segfault

	
	mov r15, 0

graphical_process:

	
	mov rdi, 0x1FF4faf25 		; background colour set to green

	mov rsi, 0x1FFF1C232	; rectangle set to brown 

	call framebuffer_clear ; framebuffer set to green

	mov rdi, [framebuffer_address]

	mov r8w, word [rectangles]		; x0 
	mov r9w, word [rectangles + 2]		; y0 

	mov r10w, word [rectangles + 4]		; x1 
	mov r11w, word [rectangles + 6]		; y1

	add r8, r15		; add r15 to x0 and x1 to move rectangles to the right
	add r10, r15

	call set_filled_rect

	mov r8w, word [rectangles + 8]		; x0 
	mov r9w, word [rectangles + 10]		; y0 

	mov r10w, word [rectangles + 12]		; x1 
	mov r11w, word [rectangles + 14]		; y1

	add r8, r15		; add r15 to x0 and x1 to move rectangles to the right
	add r10, r15

	call set_filled_rect

	mov r8w, word [rectangles + 16]		; x0 
	mov r9w, word [rectangles + 18]		; y0 

	mov r10w, word [rectangles + 20]		; x1 
	mov r11w, word [rectangles + 22]		; y1

	add r8, r15		; add r15 to x0 and x1 to move rectangles to the right
	add r10, r15

	call set_filled_rect


	; draw the lines

before_line:

	mov esi, [line_colour]	; set lines to colour determined by user

	mov r8w, word [lines]
	mov r9w, word [lines + 2]

	mov r10w, word [lines + 4]
	mov r11w, word [lines + 6]

	add r10, r15
	add r11, r15

	call set_line

	mov r8w, word [lines + 8]
	mov r9w, word [lines + 10]

	mov r10w, word [lines + 12]
	mov r11w, word [lines + 14]

	add r10, r15
	add r11, r15

	call set_line

	mov r8w, word [lines + 16]
	mov r9w, word [lines + 18]

	mov r10w, word [lines + 20]
	mov r11w, word [lines + 22]

	add r10, r15
	add r11, r15

	call set_line


	call framebuffer_flush

	inc r15

	cmp r15, 800
	jne graphical_process


	ret

	
%endif


	
