	;;  use a loop that moves each individual letter into the memory area that rsi points to, when you reach 0, print the string using write syscall
	;; the memory should be stack allocated

	;; try having the read syscall come immediately after the write syscall, this might explain why the first string ends at the correct tage, but the other strings go over the limit

	;; try the other assemblers, tasm, yasm, sasm, gas and masm, see which works

	default rel
	
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
	answer2 resb 1

	section .text
	global _start

_start:	


	mov rax, 0x1
	mov rdi, 0x1
	mov rsi, Intro
	mov rdx, IntroLength
	syscall

	mov rax, 0x0
	mov rdi, 0x0
	mov rsi, answer
	mov rdx, 2
	syscall

	mov al, [answer]

	cmp rax, 0x79
	je death_script

	mov rax, 0x1
	mov rdi, 0x1
	mov rsi, injury
	mov rdx, injurylength
	syscall

cover_up_decision:

	mov rax, 0x0
	mov rdi, 0x0
	mov rsi, answer
	mov rdx, 2
	syscall
	
	mov al, [answer]
	cmp rax, 0x79
	je cover_up
	jmp no_cover_up

death_script:

	mov rax, 0x1
	mov rdi, 0x1
	mov rsi, death
	mov rdx, deathlength
	syscall
	jmp cover_up_decision

no_cover_up:

	mov rax, 0x1
	mov rdi, 0x1
	mov rsi, no_conspiracy
	mov rdx, no_conspiracylength
	syscall
	jmp exit

cover_up:	

	mov rax, 0x1
	mov rdi, 0x1
	mov rsi, conspiracy
	mov rdx, conspiracylength
	syscall

exit:	
	mov rax, 0x3c
	syscall
