	;; might not need mmap syscall, might be better to simply modify stack memory, then write that memory to the framebuffer

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

	cmp rax, 0x0
	jge intro_input

	lea rcx, [_start]	; load address of _start label to rcx

	mov qword [instruction_pointer], rcx ; move the address of the start label to the instruction_pointer memory location, in the error handling file

	call error_handling

intro_input:

	
	mov rax, __NR_read
	mov rdi, 0x0
	mov rsi, answer
	mov rdx, 2
	syscall

	cmp rax, 0x0
	jge main_next

	lea rcx, [intro_input]	; load address of _start label to rcx

	mov qword [instruction_pointer], rcx ; move the address of the start label to the instruction_pointer memory location, in the error handling file

	call error_handling

main_next:	

	
	mov al, [answer]


	cmp rax, 0x79
	je death_script
	
	mov rax, __NR_write
	mov rdi, 0x1
	mov rsi, injury
	mov rdx, injurylength
	syscall

	cmp rax, 0x0
	jge cover_up_decision

	lea rcx, [main_next]	; load address of _start label to rcx

	mov qword [instruction_pointer], rcx ; move the address of the start label to the instruction_pointer memory location, in the error handling file

	call error_handling



cover_up_decision:

	mov rax, __NR_read
	mov rdi, 0x0
	mov rsi, answer
	mov rdx, 2
	syscall

	cmp rax, 0x0
	jge main_second

	lea rcx, [cover_up_decision]	; load address of relevant label to rcx

	mov qword [instruction_pointer], rcx ; move the address of the start label to the instruction_pointer memory location, in the error handling file

	call error_handling
	
main_second:	
	
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

	cmp rax, 0x0
	jge decision_next

	lea rcx, [death_script]	; load address of relevant label to rcx

	mov qword [instruction_pointer], rcx ; move the address of the relevant label to the instruction_pointer memory location, in the error handling file

	call error_handling

decision_next:	
	jmp cover_up_decision

no_cover_up:

	mov rax, __NR_write
	mov rdi, 0x1
	mov rsi, no_conspiracy
	mov rdx, no_conspiracylength
	syscall

	cmp rax, 0x0
	jge cover_up_next

	lea rcx, [no_cover_up]	; load address of relevant label to rcx

	mov qword [instruction_pointer], rcx ; move the address of the relevant label to the instruction_pointer memory location, in the error handling file

	call error_handling
	
cover_up_next:	
	jmp exit

cover_up:	

	mov rax, __NR_write
	mov rdi, 0x1
	mov rsi, conspiracy
	mov rdx, conspiracylength
	syscall

	cmp rax, 0x0
	jge exit

	lea rcx, [cover_up]	; load address of _start label to rcx

	mov qword [instruction_pointer], rcx ; move the address of the start label to the instruction_pointer memory location, in the error handling file

	call error_handling

exit:	
	mov rax, 0x3c
	syscall



