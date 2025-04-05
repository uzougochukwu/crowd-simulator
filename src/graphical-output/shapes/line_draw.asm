	;; need to start with perceived x and y coordinates
	;; then have routine to convert those coordinates into a memory location
	;; then do all the drawing, using the bresenham methods
	;; understand purpose of lseek and movzdx in framebuffer_flush
	;; create internal rules about which register contains which data, so that calling routines work well together
	;; draw line between r11,r12 (x0, y0) and r13,r14 (x1, y1)

	

	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/system/syscalls.asm"
	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/framebuffer/framebuffer_clear.asm"
	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/framebuffer/framebuffer_flush.asm"
	%include "/home/calebmox/crowd-simulator/src/graphical-output/library/system/error_handling.asm"


	
