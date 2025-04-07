	;; need to start with perceived x and y coordinates
	;; then have routine to convert those coordinates into a memory location
	;; then do all the drawing, using the bresenham methods
	;; understand purpose of lseek and movzdx in framebuffer_flush
	;; create internal rules about which register contains which data, so that calling routines work well together
;; draw line between r8,r9 (x0, y0) and r10,r11 (x1, y1)
	; using rdi as the start memory address and the colour in rsi

	

	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/system/syscalls.asm"
	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/framebuffer/framebuffer_clear.asm"
	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/framebuffer/framebuffer_flush.asm"
	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/system/error_handling.asm"

	; use y = mx + c to test code
	; rcx will contain m
	; rdx will contain c
	
line_draw:


	; all coordinates double
	shl r8, 1
	shl r9, 1

	shl r10, 1
	shl r11, 1

	; setting up the calculation for m
	mov r12, r9
	mov r13, r11

	sub r13, r12 		; r13 = y1 - y0

	mov r12, r8
	mov r14, r10

	sub r14, r12		; r14 = x1 - x0

	mov rax, r13
	div r14			; m = (y1 - y0) / (x1 - x0). rax = m

	mov rcx, rax		; rcx = m


	; now calculating c using y - mx = c
	mov r14, rcx
	mov r15, r8		

	imul r15, r14		; r15 = mx

	mov rdx, r9

	sub rdx, r15 		; rdx = c
	
	
	; rcx = m

	; rdx = c
	
	
        ;; the code below tests all four surrounding pixels for line intersection
	;; then divides the coords by two and uses the set_pixel function to colour in that pixel

        ;; it tests the value in r8 and r9 (x0, x1) for whether or not they equal r10 and r11 (x1, y1)
;; if they do, it stops and exits the program

	;; x, y is r8, r9

;; upper pixel

upper_pixel:
	
	sub r9, 2		; decrease the y coordinate by two, in order to reach the pixel one above, must decrease because y coord increases as you go down screen, must decrease by 2 as we have previously doubled coords 

	; test how far away from the line it is
	; use y = mx + c to see how close upper pixel is to the line

	mov r15, rcx		; r15 = m

	imul r15, r8		; r15 = mx

	add r15, rdx		; r15 = mx + c, r15 = theoretical y

	; have to test the scenario where actual y is greater than theoretical and the reverse

	cmp r9, r15		; compare r9, y, with r15, theoretical y

	jg upper_actual_greater ; if r9, y is greater than theoretical y, jump to upper_actual_greater

	sub r15, r9		; since r9, y, is less than r15, theoretical y we do r15 - r9

	cmp r15, 1		; compare the gap with 1

	jg upper_actual_greater

	; if the gap is more than one, go to upper actual greater (it could be two complement negative)
	; then divide the coordinates by 2 and call the set_pixel routine
	shr r9, 1
	shr r8, 1

	call set_pixel

	; multiply by 2

	shl r8, 1
	shl r9, 1

upper_actual_greater:

	; r9, y, is greater than r15, theoretical y

	mov rax, r9		; move r9, y, into rax so we dont modify r9
	sub rax, r15		; do rax - r15

	cmp rax, 1		; compare the difference with 1

	jg left_pixel		; if the gap is greater than 1, check the left pixel

	; else, divide the coords by 2 and call the set_pixel routine
	shr r9, 1
	shr r8, 1

	call set_pixel
	; multiply by 2

	shl r8, 1
	shl r9, 1

left_pixel:

	add r9, 2		; increase y coord by two, for reasons explained on line 72
	sub r8, 2		; decrease x coord by two, to move to left pixel

	; we have to go through the process to make r15 = mx again because we subtracted r9 from r15 earlier on
	mov r15, rcx		; r15 = m
	imul r15, r8		; r15 = mx

	add r15, rdx		; r15 = mx + c, r15 = theoretical y

	; have to test the scenario where actual y is greater than theoretical and the reverse

	cmp r9, r15             ; compare r9, y, with r15, theoretical y

	jg left_actual_greater

	sub r15, r9             ; since r9, y, is less than r15, theoretical y we do r15 - r9

	cmp r15, 1		; compare the gap with 1

	jg left_actual_greater

	; if the gap is more than one, go to upper actual greater (it could be two complement negative)
	; then divide the coordinates by 2 and call the set_pixel routine

	shr r9, 1
	shr r8, 1

	call set_pixel

	; multiply by 2

	shl r9, 1
	shl r8, 1

left_actual_greater:

	; r9, y, is greater than r15, theoretical y

	mov rax, r9		; move r9 into rax so we dont modify r9
	sub rax, r15		; do rax - r15
	
	cmp rax, 1		; compare the difference with 1

	jg bottom_pixel		; if the difference is greater than 1

	shr r8, 1		; else divide the coords by 2 and call set pixel
	shr r9, 1

	call set_pixel

	; multiply by 2
	shl r8, 1
	shl r9, 1

bottom_pixel:
	
finished:

	ret

	
