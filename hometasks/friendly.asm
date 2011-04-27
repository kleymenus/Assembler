include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert x: $"
	s2 db "Insert y: $"
	s3 db "Numbers are not friendly$"
	s4 db "Numbers are friendly$"
	;---Variables---
	summ1 dw ?
	summ2 dw ?
	x dw ?
	y dw ?
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
		sub bx, bx

		mov summ1, 0
		mov summ2, 0
	;поиск суммы делителей первого числа
		mov dx, offset s1			;
		outstr					;ввод x
		inint x					;
		sub dx,dx

		mov cx, x				;cx = x - 1
		sub cx, 1
	loop1:
		mov ax, x	
		div cx

		cmp dx, 0
		je _add1
		jmp _else1
		_add1:
			add summ1, cx
		_else1:
		
		sub dx, dx
	loop loop1

	;поиск суммы делителей второго числа
		sub cx, cx

		mov dx, offset s2			;
		outstr					;ввод y
		inint y					;
		sub dx,dx

		mov cx, y				;cx = y - 1
		sub cx, 1
	loop2:
		mov ax, y	
		div cx

		cmp dx, 0
		je _add2
		jmp _else2
		_add2:
			add summ2, cx
		_else2:
		
		sub dx, dx
	loop loop2

	;ответ
		sub bx, bx
		mov bx, y
		cmp summ1, bx

		je summ1_eq_y
		jmp _not_fr

	summ1_eq_y:
		sub bx, bx
		mov bx, x
		cmp summ2, bx
		je _fr
		jmp _not_fr
	_fr:
		mov dx, offset s4
		outstr
		jmp _break
	_not_fr:
		mov dx, offset s3
		outstr
	_break:
		newline
		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
