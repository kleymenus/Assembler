include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert n: $"
	s2 db "Yes$"
	s3 db "No$"
	n dw ?
	a dw ?
	b dw ?
	;---Variables---
ends data

code segment
	main proc				
		assume ds:data, cs:code, ss:stk		;сопоставление сегментам указанных регистров
		
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		;-------user code--------
		sub cx, cx
		sub ax, ax
		
		mov dx, offset s1			;
		outstr					;ввод n
		inint n					;
		sub dx,dx
		mov cx, n
		sub cx, 2

		inint a
		inint b
		mov al, 1

		mov dx, b	; dx = b -a
		sub dx, a
	_seq:
		mov bx, b	; a = b
		mov a, bx
		inint b

		mov bx, a	;bx = a+dx
		add bx, dx

		cmp bx, b
		je _dont_chng_fl
		mov al, 0
		_dont_chng_fl:
	loop _seq

		cmp al, 0
		je al_0
		mov dx, offset s2
		outstr
		jmp _break
	al_0:
		mov dx, offset s3
		outstr
	_break:
	
		newline


		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
