include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert n: $"
	s2 db "Max negative number: $"
	;---Variables---
	n dw ?
	fl db 0	
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
		mov cx, n

		mov ax, -32768				;наименьшее число помещающееся в слово

	_seq:
		inint bx	

		cmp bx, 0
		jge _dont_cmp
		cmp bx, ax
		jle _dont_cmp
		mov ax, bx

		cmp bx, 0
		jge _dont_cmp
		mov fl, 1	
		_dont_cmp:
	loop _seq
		newline
	
		cmp fl, 1
		jne _break
		mov dx, offset s2
		outstr
		outint ax
		_break:

		newline


		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
