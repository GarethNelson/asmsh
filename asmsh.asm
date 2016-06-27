extern _printf
extern _exit
extern _readline
extern _free
extern _strncmp
extern _getcwd
extern _getlogin
extern _gethostname
extern _system
extern _fork
extern _execve
extern environ

section .data
	UNIX_PROMPT: db "%s@%s:%s$ ",0
	PROMPT_STR: db "",0
	INLINE_STR: dd 0
	HOSTNAME_STR: times 50 db 0
	
	QUIT_CMD_STR: db "quit",10,0
	

section .text
	global _main

_main:

sh_loop:
	call unix_prompt

	push rbp
	mov rdi,PROMPT_STR
	call _readline
	pop rbp
	
	mov  r14,rax

	mov rdi,r14
	mov rsi,QUIT_CMD_STR
	mov rdx,4
	push rbp
	call _strncmp
	pop rbp

	mov r15,rax
	cmp r15,0
	je freecmdline
		
	push rbp
	mov rdi,r14
	call _system
	pop rbp

freecmdline:	
	push rbp
	mov rdi,r14
	call _free
	pop rbp

	cmp r15,0
	jne sh_loop
quit:
	push rbp
	mov rdi,0
	mov rax,0
	call _exit
	pop rbp

unix_prompt:
	mov rdi,0
	call _getlogin
	mov r12, rax

	mov rdi, HOSTNAME_STR
	mov rsi, 49
	call _gethostname
	mov r13, HOSTNAME_STR

	mov rdi,0
	call _getcwd
	mov r14,rax
	
	mov rdi,UNIX_PROMPT
	mov rsi,r12
	mov rdx,r13
	mov rcx,r14
	call _printf
	mov rdi,r14
	call _free

	ret