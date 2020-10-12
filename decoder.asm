%macro createFile 2				; file_name, file_descriptor
	mov eax, sys_create
	mov ebx, %1
	mov ecx, 7777h				; set all permissions
	int	0x80
	mov	dword[%2], eax				; move file descriptor
%endmacro

%macro openFile 3				; file_name, open_mode, file_descriptor
	mov eax, sys_open
	mov ebx, %1
	mov ecx, %2
	int	0x80
	mov [%3], eax				; move file descriptor
%endmacro

%macro readFile 3				; file_descriptor, where to save, number of bytes
	mov 	eax, sys_read
	mov 	ebx, [%1]
	mov 	ecx, %2
	mov 	edx, %3
	int		0x80	
%endmacro

%macro writeFile 3				; file_descriptor, where to write, number of bytes
	mov 	eax, sys_write
	mov 	ebx, [%1]				; file descriptor
	mov 	ecx, %2
	mov 	edx, %3
	int		0x80
%endmacro

%macro updateFileDescriptor 3
	mov		eax, sys_lseek
	mov 	ebx, [%1]				; file descriptor
	mov		ecx, [%2]
	mov		edx, %3
	int		0x80
%endmacro

%macro	closeFile 1
	mov 	eax, sys_close
	mov 	ebx, [%1]
	int		0x80
%endmacro

%macro exit 0
	mov		eax, sys_exit
	mov		ebx, 0
	int		0x80
%endmacro

%macro writeInConsole 2
	mov 	eax, sys_write	
	mov 	ebx, 1
	mov 	ecx, %1
	mov 	edx, %2
	int		0x80
%endmacro

%macro readNumber 1				; number, , 
	mov al,0
	mov [%1],al
%%read_number1:

	;*****************************this part will by a separate macro
	updateFileDescriptor	fd_in, img_index, seek_set
	readFile				fd_in, pixel_value, pixel_size
	mov ebx,[img_index]										;update image index after read byte
	add ebx,1
	mov [img_index],ebx
	;***********************************************


	mov al,[pixel_value]
	cmp al,32
	je %%end_read_number				; if is equal to blank space " " jumpt to the next number2


	mov al,[%1]
	mov bl,10
	mul bl
	mov [%1],al


	mov al,[pixel_value]
	sub al,'0'
	add al,[%1]
	mov [%1],al
	;writeInConsole 	%1,pixel_size
	;writeFile		fd_out, %1, 1
	jmp %%read_number1
%%end_read_number:
%endmacro


section .data
	sys_exit			equ	1
	sys_open			equ	5
	sys_read			equ	3
	sys_write			equ	4
	sys_lseek			equ	19
	seek_set			equ	0
	sys_create			equ	8
	sys_close			equ	6
	img_input_encrypted		db	'files/Imagen.txt', 0
	img_output_decryption	db	'files/output_decryption.txt', 0
	read_only			equ	0
	pixel_size			equ	1
	;show messages
	msg		db "Initial configure complete!!!",0x0a
	len 	equ $ - msg  ;
	msg2	db "no salta!!!",0x0a
	len2 	equ $ - msg2  ;

section .bss
	fd_out				resd	1
	fd_in 				resd	1
	pixel_value			resb	1	
	img_index			resd	1
	number1				resb 	1

	number2				resb	1

	numberTot			resw	4
section .text

	global _start

_start:
	createFile	img_output_decryption, fd_out
	openFile	img_input_encrypted, read_only, fd_in

	writeInConsole msg,len
	mov eax, 0
	mov [img_index],eax

	;****************************************************************




	;****************************************************************


	readNumber number1
	writeInConsole number2,1
	writeFile				fd_out, number1, 1
	readNumber number2
	writeInConsole number2,1
	writeFile				fd_out, number2, 1
	closeFile	fd_in
	closeFile	fd_out
	exit