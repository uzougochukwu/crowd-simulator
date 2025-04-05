	;; need to define registers for the width and height of the framebuffer
	;;  no need for a routine to convert coordinates to memory, just do it in the calculation at the start
	;; rsi should contain the colour we set the pixel too.
        ;; designate a register to contain the framebuffer start address, then add that address to the x and y coords multiplied by bytes per pixel
	;; sets the pixel at x (r11) and y (r12) to the colour defined in rsi
;;  this pixel routine must be called for every pixel that we set, ultimately
	; check whether esi is the correct register to move into the memory address
	; check whether we can draw several pixels in a row
	; check whether we need to divide by 4

	; need to have the start address in a register
	; need the width and height of the framebuffer
	; need to use xmdi formula
	; change registers to match xmdi system
	; the address is linear, but you are going through a rectanglar screen
	; that is why you need to calculate P

        %include "/home/calebmox/crowd-simulator/src/graphical-output/library/system/syscalls.asm"
	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/framebuffer/framebuffer_info.asm"
	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/framebuffer/framebuffer_clear.asm"
	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/framebuffer/framebuffer_flush.asm"
        %include "/home/calebmox/crowd-simulator/src/graphical-output/library/system/error_handling.asm"

section .text

	; P = ((y res - y coord - 1) * x res ) + x coord
	; address = (4 * P) + start of framebuffer address
	;

set_pixel:
	
	mov r15, [y]		; y resolution into r15
	mov r14, [x]		; x resolution into r14

	; calculate P

	sub r15, r12
	dec r15

	imul r15, r14
	add r15, r11

	; P is stored in r15
	imul r15, 4
	add r15, [framebuffer_address]
	

	mov dword [r15], esi

	ret
