%ifndef SET_FILLED_RECT
%define SET_FILLED_RECT

%include "/home/calebmox/crowd-simulator/src/graphical-output/shapes/set_line.asm"

set_filled_rect:
	; draw filled rectangle r8,r9 (x0,y0) to r10,r11 (x1,y1)
	; in framebuffer array starting at memory defined in rdi
	; of rdx x rcx (width x height) framebuffer
	; with a fill colour defined in rsi


	push r8
	push r9
	push r10
	push r11
	push rax

	cmp r11, r9
	je final
	jg top_down
	mov rax, -1
	jmp start

top_down:
	mov rax, 1

start:
	mov r11, r9

	; go_through all rows

go_through:

	call set_line

	add r9, rax
	add r11, rax

	cmp r9, [rsp+8]
	jne go_through

	call set_line


final:
	pop rax
	pop r11
	pop r10
	pop r9
	pop r8

	ret

	%endif
	
