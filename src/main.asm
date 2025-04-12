

	default rel
%include "/home/calebmox/crowd-simulator/src/graphical-output/library/system/syscalls.asm"
%include "/home/calebmox/crowd-simulator/src/graphical-output/library/system/error_handling.asm"
	
	section .rodata

no_conspiracy:	db "We made mistakes that lead to the disaster"
no_conspiracylength:	equ $-no_conspiracy

Intro:	db "Welcome to your new role as head of crowd security. Good luck!",0ah,"Would you like to equip the riot police with lethal ammunition?"
IntroLength:	equ $-Intro	

	
death:	db "This is the after action report. 17 people have been killed and over 100 people were injured, many severely.",0ah,"Should we cover this up?"
deathlength:	equ $-death

conspiracy:	db "Due to rowdy behaviour amongst fans, a riot developed, resulting in disaster."
conspiracylength:	equ $-conspiracy


injury:	db "This is the after action report. No fatalities reported, 4 minor injuries amongst guests.",0ah,"Should we cover this up?"
injurylength:	equ $-injury


	section .bss
	answer resq 8


	section .text
	global _start

_start:	


	mov rax, __NR_write
	mov rdi, 0x1
	mov rsi, Intro
	mov rdx, IntroLength
	syscall

	call error_handling	; defined in syscalls.asm

	
	mov rax, __NR_read
	mov rdi, 0x0
	mov rsi, answer
	mov rdx, 2
	syscall

	call error_handling

	
	mov al, [answer]


	cmp rax, 0x79
	je death_script
	
	mov rax, __NR_write
	mov rdi, 0x1
	mov rsi, injury
	mov rdx, injurylength
	syscall

	call error_handling

cover_up_decision:

	mov rax, __NR_read
	mov rdi, 0x0
	mov rsi, answer
	mov rdx, 2
	syscall

	call error_handling
	
	mov al, [answer]
	cmp rax, 0x79
	je cover_up
	jmp no_cover_up

death_script:

	mov rax, __NR_write
	mov rdi, 0x1
	mov rsi, death
	mov rdx, deathlength
	syscall

	
decision_next:	
	jmp cover_up_decision

no_cover_up:

	mov rax, __NR_write
	mov rdi, 0x1
	mov rsi, no_conspiracy
	mov rdx, no_conspiracylength
	syscall

	call error_handling

	
cover_up_next:	
	jmp exit

cover_up:	

	mov rax, __NR_write
	mov rdi, 0x1
	mov rsi, conspiracy
	mov rdx, conspiracylength
	syscall

	call error_handling

exit:	
	mov rax, 0x3c
	syscall



