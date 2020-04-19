; Created following the https://asmtutor.com/ tutorial

; Strlen subroutine
strlen:
	push ebx
	mov ebx, eax

nextchar:
	cmp byte [eax], 0
	jz finished
	inc eax
	jmp nextchar

finished:
	sub eax, ebx
	pop ebx
	ret
	
; Sprint subroutine (prints string)
sprint:
	push edx
	push ecx
	push ebx
	push eax
	call strlen 
	
	mov edx, eax
	pop eax

	mov ecx, eax
	mov ebx, 1
	mov eax, 4
	int 80h

	pop ebx
	pop ecx
	pop edx
	ret

; Exit program subroutine
quit:
	mov ebx, 0
	mov eax, 1
	int 80h
	ret
	
; Prints line with endline char
sprintLF:
	call sprint

	push eax 	; Saving eax
	mov eax, 0Ah
	push eax 
	mov eax, esp
	call sprint 
	pop eax 
	pop eax
	ret

; iprint : prints integer
iprint:
	push 	eax
	push 	ecx
	push 	edx
	push 	esi
	mov ecx, 0

divideLoop:
	inc 	ecx
	mov 	edx, 0
	mov 	esi, 10
	idiv 	esi
	add 	edx, 48
	push 	edx
	cmp 	eax, 0
	jnz 	divideLoop
	
printLoop:
	dec 	ecx
	mov 	eax, esp
	call 	sprint
	pop 	eax
	cmp 	ecx, 0
	jnz 	printLoop

	pop 	esi
	pop 	edx
	pop 	ecx
	pop 	eax
	ret

; iprintLF prints line with newline char
iprintLF:
	call 	iprint
	push 	eax
	mov 	eax, 0Ah
	push 	eax
	mov 	eax, esp
	call 	sprint
	pop 	eax
	pop 	eax
	ret

; ASCII to integer function
atoi:
	push 	ebx 	; Preserving registers on the stack
	push 	ecx	
	push 	edx
	push 	esi 
	mov 	esi, eax
	mov 	eax, 0
	mov 	ecx, 0

.multiplyLoop:
	mov 	ebx, 0	; Setting ebx to 0
	mov 	bl, [esi + ecx]
	cmp 	bl, 48	; Check if char is an integer
	jl 	.finished
	cmp 	bl, 57
	jg 	.finished

	sub 	bl, 48
	add 	eax, ebx 
	mov 	ebx, 10
	mul 	ebx
	inc 	ecx 
	jmp 	.multiplyLoop

.finished:
	mov 	ebx, 10
	div 	ebx

	pop 	esi	; Restoring registers from the stack
	pop 	edx
	pop 	ecx
	pop 	ebx
	
	ret	

