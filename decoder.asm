;Extra information to solve
;byte = 8 bits   	--->resb
;word = 16 bits		--->resw
;dword = 32 bits	--->resd
;qword = 64	bits	--->resq


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
	jmp %%read_number1
%%end_read_number:
%endmacro

;*******************************************************************************************

%macro DecodeNum 1
	mov eax,0 
	mov eax,[%1]						; eax <-- numberTot
	mov [temp_num_tot],eax				; temp_num_tot <-- numberTot
	mov eax,0							; eax <-- 0
	mov [result_parcial],eax			; result_parcial <-- 0
	mov eax,num_D 						; ax <-- num_D 
	;shr ax,1
	mov [temp_num_D],eax					; temp_num_D <-- num_D
	
	mov ax,num_D 						; ax <-- num_D
	mov bx,1							; bx <-- 1
	and ax,bx							; ax <-- ax and bx  ----> ax es: 1 si el ultimo bit es 1 o 0 si es 0
	cmp ax,1							; compara si ax es 1 
	jne %%parcialEqual1					; salta a result_parcial <-- 1 si es 0
		mov eax,[temp_num_tot]				; ax <-- temp_num_tot
		mov [result_parcial],eax				; result_parcial <-- temp_num_tot
		jmp %%calc_cicle					; salta al ciclo
	%%parcialEqual1:					; 
		mov eax,1
		mov [result_parcial],eax
	%%calc_cicle:
		;writeFile				fd_out, temp_num_tot, 4
		mov eax,[temp_num_tot]				; eax <-- temp_num_tot
		mov ebx,[temp_num_tot]
		mul ebx							; eax <-- temp_num_tot * temp_num_tot
		mov [temp_num_tot],eax
		;writeFile				fd_out, temp_num_tot, 4
		mov eax, [temp_num_tot]
		mov ebx,num_N						; ebx <-- num_N
		mov edx,0							; edx <-- 0
		div ebx								; edx <-- (temp_num_tot^2) mod num_N
		mov [temp_num_tot],edx				; temp_num_tot <-- (temp_num_tot^2) mod num_N
		
		mov ax,[temp_num_D]					;
		shr ax,1
		mov [temp_num_D],ax					;decrementa 1 temp_num_D
		;writeFile				fd_out, result_parcial, 2
		;writeFile				fd_out, msg2, len2
		;mov ax,[temp_num_D]
		mov bx,1
		mov ax,[temp_num_D]
		and ax,bx
		cmp ax,1
		jne %%next_calc
			mov eax,[result_parcial]				; eax <-- result_parcial
			mov ebx,[temp_num_tot]					; ebx <-- temp_num_tot
			mul ebx									; eax <--  (result_parcial * temp_num_tot)
			mov edx,0								; set 0 to the pos of module division
			mov ebx,num_N 							; ebx <-- num_N
			div ebx									; eax <-- eax//ebx;  edx <-- eax mod ebx
			mov [result_parcial],edx				; (result_parcial*temp_num_tot) mod num_N
	%%next_calc:
		;writeFile fd_out,result_parcial,2
		mov ax,[temp_num_D]							;mov ax
		cmp ax,0
		jne %%calc_cicle							;if temp_num_D  == 0 ends
	
	mov eax,[result_parcial]
	mov [%1],eax
%endmacro
;*******************************************************************************************



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
	msg2	db " ",0x0a
	len2 	equ $ - msg2  ;

	num_D 				equ 3163
	num_N				equ 3599


section .bss
	fd_out				resd	1
	fd_in 				resd	1
	pixel_value			resb	1	
	img_index			resd	1
	number1				resb 	1
	number2				resb	1
	numberTot			resd	1

	temp_num_tot		resd	1
	temp_num_D			resw	1
	result_parcial		resd	1
section .text

	global _start

_start:
	createFile	img_output_decryption, fd_out
	openFile	img_input_encrypted, read_only, fd_in

	writeInConsole msg,len
	mov eax, 0
	mov [img_index],eax

	;****************************************************************
	readNumber number1
	
	readNumber number2
	
	;****************************************************************
	mov eax,0
	mov eax,[number1]
	shl eax,8
	add eax,[number2]
	mov [numberTot],eax
	shl eax,16
	shr eax,16
	mov [numberTot],eax
	writeFile fd_out,numberTot,4

	DecodeNum numberTot
	writeFile fd_out,numberTot,4

	
	

	closeFile	fd_in
	closeFile	fd_out
	exit