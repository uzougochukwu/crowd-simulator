%ifndef SET_LINE
%define SET_LINE
	

;; create internal rules about which register contains which data, so that calling routines work well together
;; draw line between r8,r9 (x0, y0) and r10,r11 (x1, y1)
	; using rdi as the start memory address and the colour in rsi
	; for image of rdx by rcx (width by height)

        %include "/home/calebmox/crowd-simulator/src/graphical-output/shapes/set_pixel.asm"
	
	
line_draw:

	cmp r8, r10
	je vertical_line
	cmp r9, r11
	je horizontal_line

	push rax
	push rbx
	push r8
	push r9
	push r12
	push r13
	push r14
	push r15

	mov r12, r10
	sub r12, r8
	test r12, r12
	jns abs_dx
	neg r12

abs_dx:
	mov r13, r11
	sub r13, r9
	test r13, r13
	jns abs_dy
	neg r13


abs_dy:

	cmp r13, r12
	jge plot_line_up

plot_line_down:
	cmp r8, r10
	jle plot_down		; plot line down forwards
	mov r12, r10
	mov r10, r8
	mov r8, r12
	mov r12, r11
	mov r11, r9
	mov r9, r12
	jmp plot_down		; plot line down backwards

plot_line_up:

	cmp r9, r11
	jle plot_up		; plot line up forwards
	mov r12, r10
	mov r10, r8
	mov r8, r12
	mov r12, r11
	mov r11, r9
	mov r9, r12
	; plot line up backwards

plot_up:
	mov r12, r10
	sub r12, r8		; dx = x1 - x0
	mov r13, r11
	sub r13, r9		; dy = y1 - y0
	mov rax, 1		; x_step = 1
	test r12, r12
	jns plot_abs_dx
	neg r12			; dx = -dx
	neg rax			; x_step = -1

plot_abs_dx:
	mov rbx, r12
	shl rbx, 1
	mov r14, rbx		; 2*dx
	sub rbx, r13		; D = 2dx-dy
	mov r15, r13
	shl r15, 1
	sub r15, r14
	neg r15			; 2dx-2dy

loop_up:
	call set_pixel 		; draw the current pixel
	cmp r9, r11		; if we're done, return
	je ret
	cmp rbx, 0		; if D <= 0, don't adjust x
	jle dont_adjust_x
	add r8, rax		; x += x_step
	add rbx, r15		; D += (2dx-2dy)
	inc r9			; y++
	jmp loop_up
dont_adjust_x:
	add rbx, r14		; D += 2dx
	inc r9			; y++
	jmp loop_up

plot_down:
	mov r12, r10
	sub r12, r8		; dx = x1-x0
	mov r13, r11
	sub r13, r9		; dy = y1-y0
	mov rax, 1		; y_step = 1
	test r13, r13
	jns plot_abs_dy
	neg r13			; dy = -dy
	neg rax			; y_step = -1

plot_abs_dy:
	mov rbx, r13
	shl rbx, 1
	mov r14, rbx		; 2*dy
	sub rbx, r12		; D = 2dy - dx
	mov r15, r12
	shl r15, 1
	sub r15, r14
	neg r15			; 2dy-2dx

loop_down:
	call set_pixel		; draw the current pixel
	cmp r8, r10		; if we're done, return
	je ret
	cmp rbx, 0		; if D <= 0, domt adjust y
	jle dont_adjust_y
	add r9, rax		; y += y_step
	add rbx, r15		; D += (2dy-2dx)
	inc r8			; x++
	jmp loop_down

dont_adjust_y:
	add rbx, r14		; D += 2dy
	inc r8			; x++
	jmp loop_down

ret:
	pop r15
	pop r14		
	pop r13
	pop r12
	pop r9
	pop r8
	pop rbx
	pop rax

	ret

vertical_line:
	push rax
	push r9
	push r11

	cmp r9, r11
	jl loop_vertical
	mov rax, r9
	mov r9, r11
	mov r11, rax

loop_vertical:
	call set_pixel
	inc r9
	cmp r9, r11
	jle loop_vertical

	pop r11
	pop r9
	pop rax
	ret

horizontal_line:
	push rax
	push r8
	push r10

	cmp r8, r10
	jl loop_horizontal
	mov rax, r8
	mov r8, r10
	mov r10, rax

loop_horizontal:
	call set_pixel
	inc r8
	cmp r8, r10
	jle loop_horizontal

	pop r10
	pop r8
	pop rax
	ret

	%endif
