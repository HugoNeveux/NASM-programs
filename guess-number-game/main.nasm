; Guess number game in NASM 

; Assemble with nasm -f elf main.nasm
; And 		ld -m elf_i386 main.o -o main.bin	

%include '../base/functions.nasm'

section .data
welcome	DB	"Welcome ! I'll pick a number between 0 and 255, and you'll have to guess it. Ready ?", 0h
input_msg	DB	"Please enter a number : ", 0h
finish_msg	DB	"Congratulations ! The unknown number was ", 0h
more_msg	DB	"My number is bigger than your input !", 0h
less_msg	DB	"My number is smaller than your input !", 0h
counter_msg	DB	"Number of tries before finding the number : ", 0h
retry_msg 	DB	"Would you like to continue playing ? [y/n] ", 0h

section .bss
user_input_ascii:	resb	255
user_input:	resq	1
unknown_nb: 	resq 	1
counter:	resb	1

section .text
global _start

_start:
	; Printing welcome
	mov 	eax, welcome
	call 	sprintLF

	; Storing random number into unknown_nb
	call 	rand
	mov 	[unknown_nb], al
	xor 	eax, eax

	
input:
	; Incerase counter
	mov	dl, [counter]
	inc 	dl
	mov	[counter], dl

	; Printing input 
	mov	eax, input_msg
	call 	sprintLF

	; Reading user input
	mov 	edx, 255 
	mov 	ecx, user_input_ascii
	mov 	ebx, 0
	mov 	eax, 3
	int 	80h
	
	; Converting input to integer
	mov	eax, user_input_ascii
	call 	atoi
	mov 	[user_input], eax

	; Showing user input
	; mov 	eax, [user_input]
	; call	iprintLF


	; Check user input
	mov 	eax, [user_input]
	mov 	ebx, [unknown_nb]
	cmp	eax, ebx 
	jg 	less
	jl	more
	
	
finish:
	; Printing congratulations message
	mov	eax, finish_msg
	call 	sprint

	mov	eax, [unknown_nb]
	call	iprintLF

	; Show number of tries
	mov 	eax, counter_msg
	call 	sprint
	
	xor	eax, eax
	mov 	eax, [counter] 
	call 	iprintLF

continue:
	mov 	eax, retry_msg
	call 	sprint

	; Reading user input
	mov 	edx, 255 
	mov 	ecx, user_input_ascii
	mov 	ebx, 0
	mov 	eax, 3
	int 	80h

	; Print user_input_ascii content
	mov	eax, user_input_ascii
	call 	iprintLF
	
	; Compare input
	mov	eax, [user_input_ascii]
	mov 	ebx, "y"
	cmp 	eax, ebx
	je 	_start

	call 	quit

more:
	mov	eax, more_msg
	call	sprintLF
	jmp 	input

less:
	mov	eax, less_msg
	call	sprintLF
	jmp	input
	

rand:
; Using linear-congruential generator with 
; (Xn+1 = (1103515245 * Xn + 12345) % 2^31
	push	ebx	; Save ebx on the stack
	rdtsc
	; Xn * 1103515245
	mov 	ebx, 1103515245
	mul 	ebx
	; + 12345
	add 	eax, 12345

	; Modulo 2^31 (and 2^31 - 1)
	and 	eax, 2147483647 

	pop 	ebx	; Restore ebx from the stack

	ret

