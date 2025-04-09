%ifndef SET_PIXEL
%define SET_PIXEL

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
	; set pixel at x, y which is r8d, r9d in the framebuffer memory starting at rdi for a width x height image which is edx x ecx, to the colour value in esi

        %include "/home/calebmox/crowd-simulator/src/graphical-output/library/system/syscalls.asm"
	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/framebuffer/framebuffer_info.asm"
	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/framebuffer/framebuffer_clear.asm"
	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/framebuffer/framebuffer_flush.asm"
        %include "/home/calebmox/crowd-simulator/src/graphical-output/library/system/error_handling.asm"

section .text

	; P = ((y res - y coord - 1) * x res ) + x coord
	; address = (4 * P) + start of framebuffer address
	

set_pixel:

	push rcx
	push rax
	
	mov rcx, [y]		; y resolution, which is height, into ecx
	mov rdx, [x]		; x resolution, which is width, into edx

	; calculate P

	sub rcx, r9
	dec rcx

	imul rcx, rdx
	add rcx, r8

	; P is stored in rcx
	shl rcx, 2		; multiply P by 4 (because it is 4 bytes per pixel

	mov rax, 0xFFFFFFFF
	and rax, rsi		; rsi contains the colour, we and rax with rsi so that the value is copied over

	mov dword [rdi+rcx], eax ; rdi has start of framebuffer address

	pop rax
	pop rcx

	ret

%endif
