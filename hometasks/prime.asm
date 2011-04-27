include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert x: $"
	s2 db "Not prime$"
	s3 db "Prime$"
	;---Variables---
	tmp dw ?
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
		
		mov dx, offset s1			;
		outstr					;ввод x
		inint bx				;
		sub dx,dx
		
		mov cx, bx				;cx = bx -2
		sub cx, 2
	loop1:
		mov ax, bx	
		mov tmp, cx
		add tmp, 1
		div tmp

		cmp dx, 0
		je _not_prime
		
		sub dx,dx
	loop loop1
		mov dx, offset s3
		outstr
		jmp _break
	_not_prime:
		mov dx, offset s2
		outstr
	_break:

		newline
		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
