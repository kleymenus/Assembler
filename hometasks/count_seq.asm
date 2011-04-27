include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert n: $"
	s2 db "Count: $"
	n dw ?
	a dw ?
	b dw ?
	c dw ?
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
		sub cx, 3

		inint a
		inint b
		inint c

		mov dx, c
		cmp a, dx 
		jne _dont_inc1
		inc bx
		_dont_inc1:

	_seq:
		mov ax, b	; a=b
		mov a, ax
		mov ax, c	; b = c
		mov b, ax
		inint c

		mov dx, c
		cmp a, dx 
		jne _dont_inc
		inc bx
		_dont_inc:
	loop _seq
		newline
	
		mov dx, offset s2
		outstr
		outint bx
		newline


		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
