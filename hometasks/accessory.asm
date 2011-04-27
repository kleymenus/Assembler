include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert a: $"
	s2 db "Insert b: $"
	s3 db "Insert x: $"
	s4 db "X in [a;b]$"
	s5 db "X out [a;b]$"
	;---Variables---
	x dw ?
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
		mov dx, offset s1			;
		outstr					;ввод a
		inint ax				;

		mov dx, offset s2			;
		outstr					;ввод b
		inint bx				;

		mov dx, offset s3			;
		outstr					;ввод x
		inint x					;

		cmp ax, x
		jle _ax_x
		jmp _break

	_ax_x:					;если ax<=x
		cmp bx, x			; то проверим bx
		jge _bx_x			;
		jmp _break			
	_bx_x:					;если bx>=x
		mov dx, offset s4		;то вывести сообщение что x
		outstr 				;принадлежит [a;b]
		jmp _done
	_break:
		mov dx, offset s5		;x не принадлежит промежутку
		outstr
	_done:
		newline

		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
