include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert a: $"
	s2 db "Insert b: $"
	s3 db "Result z = |a+b|-2|a|+3|a-b|: $"
	;---Variables---
	a dw ?
	b dw ?
ends data

code segment
	assume ds:data, cs:code, ss:stk

	abs proc
		;процедура, возращает в ax модуль ax
		cmp ax, 0
		jge _dont_change_sign
			neg ax
		_dont_change_sign:

		ret
	abs endp

	main proc				
		
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		;-------user code--------
		sub bx, bx

		mov dx, offset s1
		outstr
		inint a

		mov dx, offset s2
		outstr
		inint b

		mov ax, a		;сохранение |a+b|
		add ax, b
		call abs
		push ax

		mov ax, a		;сохранение 2*|a|
		call abs
		mov bx, 2
		mul bx 
		push ax

		mov ax, a		;вычисление 3*|a-b|
		sub ax, b
		call abs
		mov bx, 3
		mul bx 

		pop bx			;достанем 2*|a|
		sub ax, bx
		pop bx			;достанем |a+b|
		add ax, bx

		mov dx, offset s3
		outstr
		outint ax
		newline

		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
