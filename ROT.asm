extern printf
extern getchar
extern putchar

section .data
	fmt: db "There are %d character" , 10 

;section .bss

section .text

global main

main:
    push ebp 		; pushing the base pointer on to the stack 
    mov ebp, esp	; copying the stack point into the base pointer register
    push ebx	        ; Program must preserve ebp, ebx, esi, & edi
    mov ecx,0		; initializing the count to 0
loop:
	;reading from STDIN
	inc ecx 	; start the counter	
	push ecx	; push counter to the stack
	call getchar	; input glibc function to input a string storing it into eax	
	cmp eax, '{'	; compare value in eax with '{' if a special character such braces or beyond with ascii table
	jae final	; if above or equal to '{' do nothing
	cmp eax, 'n'	; compare if character in eax is lower case n 
	jae sub13	; if above or equal subtract 13
	cmp eax, 'a'	; compare if character in eax is lower case a
	jae add13	; if above or equal add 13
	cmp eax, '['	; compare with '[' 
	jae final	; if above or equal do nothing
	cmp eax, 'N'	; compare character in eax with upper case N
	jae sub13	; subtract 13 if true
	cmp eax, 'A'	; compare character in eax with upper case A
	jae add13	; add 13 if true
	jmp final
sub13:		; if value in EAX is between upper case N and upper case Z 
	sub eax, 13
	jmp final
add13:		; if value in EAX is between upper case A to M 
	add eax, 13
	jmp final
final:
	push eax	; push the changed value in EAX to the stack to save our encrypted input
	call putchar	; output glibc function to output the string
	pop eax		; clear the stack
	cmp eax,10	; Checking if EOF	
	pop ecx		; poping the counter
	jne loop	; if not equal EOF jump back to the loop 
	jmp exit
	dec ecx		; decrement counter for any extra characters
exit:
    dec ecx
    push ecx		; push counter to the stack after decrementing the extra remaining characters
    push dword fmt	; exppand fmt string to 32-bits and pushing it to the stack
    call printf		; glibc function to print this prints the count
    add esp, 8		; destroy the stack
    pop ebx		; pop any strings left in ebx
    mov esp,ebp         ; Destroy stack frame before returning
    pop ebp		; pop out the base pointer to end the program
    ret
