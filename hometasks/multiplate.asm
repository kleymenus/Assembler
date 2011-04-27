include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert a: $"
	s2 db "Insert b: $"
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
		sub bx, bx
		
		mov dx, offset s1			;
		outstr					;ввод a
		inint cx				;

		mov dx, offset s2			;
		outstr					;ввод b
		inint bx				;

		sub cx, 1	
		mov ax, bx
	loop1:
		add bx, ax
	loop loop1
		outint bx
		newline
		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
