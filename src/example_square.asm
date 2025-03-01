; byte.observer's munching square linux example
; assembles with nasm -fbin munch.asm -o munch
width equ 1024
height equ 768

fname:
db "/dev/fb0",0 ; e_shoff, p_align, e_flags, e_ehsize

	section .text
	global _start
	

	
_start:
    mov ebx,fname     ; e_phentsize, e_phnum
    inc ecx           ; = 1 = O_WRONLY
    mov al,0x02          ; 5 = open syscall
    syscall          ; open /dev/fb0 = 3

    mov ebp,width*height*4  ; ebp = screen size
            ; make room on the stack for the video memory, used to have sub esp, ebp here

mainloop:
    mov ecx,ebp    ; init pixel index
    shr ecx,2      ; divide by bits per pixel
    inc edi        ; frame counter

setpixels:
    mov ebx,width
    mov eax,ecx
    cdq
    div ebx               ; edx = x-coord , eax=y coord
    xor eax,edx           ; xor pattern
    add eax,edi           ; make it munch
    mov [esp+ecx*4+0],al ; b
    mov [esp+ecx*4+1],al ; g
    mov [esp+ecx*4+2],al ; r
    mov [esp+ecx*4+3],al ; a
    loop setpixels

    ; dump the whole thing to the screen using pwrite64 syscall
    mov ecx,esp  ; buffer ptr
    mov edx,ebp  ; screen size
    push rdi     ; save frame counter
    xor esi,esi  ; seek to beginning of screen
    xor edi,edi  
    mov ebx,3    ; fd of framebuffer
    mov eax,0x12 ; pwrite64
    syscall     ; pwrite64 to framebuffer
    pop rdi

    jmp mainloop
