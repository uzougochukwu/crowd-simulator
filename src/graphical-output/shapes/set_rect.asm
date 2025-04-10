%ifndef SET_RECT
%define SET_RECT

	; dependency

%include "/home/calebmox/crowd-simulator/src/graphical-output/shapes/set_line.asm"
%include "/home/calebmox/crowd-simulator/src/graphical-output/shapes/set_pixel.asm"

set_rect:

	; draw rectangle from r8,r9 (x0, y0) to r10,r11 (x1,y1) in framebuffer starting at rdi
	; for a framebuffer of width rdx x rcx (width x height) with a color defined by rsi

	push r8
	push r9
	push r10
	push r11

	; line from (x0,y0) to (x1,y0)
	mov r11, [rsp+16]
	call set_line

	; line from (x1,y1) to (x1,y0)
	mov r8, [rsp+8]
	mov r9, [rsp]
	call set_line

	; line from (x1,y1) to (x0, y1)
	mov r10, [rsp+24]
	mov r11, [rsp]
	call set_line

	; line from (x0,y0) to (x0,y1)
	mov r8, [rsp+24]
	mov r9, [rsp+16]
	call set_line

%if 0
	mov r10, [rsp+8]
	dec r11

	push rsi
	shr rsi, 33		; skip the inversion bit on fill check
	test rsi, rsi
	jz end


loop_rows:
	inc r9
	mov r8, [rsp+32]
	inc r8

loop_cols:
	call set_pixel
	inc r8
	cmp r8, r10
	jl loop_cols
	cmp r9, r11
	jl loop_rows

%endif

end:
	pop r11
	pop r10
	pop r9
	pop r8
	ret

	%endif
