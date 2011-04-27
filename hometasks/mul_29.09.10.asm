include io.asm

stk segment stack 
	db 100h dup(?) 
ends stk	

data segment	
	;--- constants ---
	a db 3 
	b db 12 
	c db 23 
	s1 db "Insert x: $"
	rslt db "Result: $"
	ln db 13,10,"$"

	;--- variables ---
	x	db ?
ends data

code segment
	main proc				
		assume ds:data, cs:code, ss:stk		;сопоставление сегментам указанных регистров
		
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		;---------- code ------------
		mov dx, offset s1			;printf("%s", s1)
		outstr s1				;

		inint dx				;вводим число в dx
		mov x, dl				;копируем в x младшие 8 разрядов

		mov al, a				;копируем первый сомножитель в al
		imul x					;ax = x*a
		imul x					;в al лежит 8 младших байт произведения x*a
		mov bx, ax				;bx = a*x*x	

		mov al, b				;копируем в al первый сомножитель
		imul x					;ax = b*x

		add bx,ax				;bx = a*x*x + b*x

		mov dl, c
		add bx, dx				;bx = a*x*x + b*x + c

		
		mov dx, offset ln			;printf("\n")
		outstr ln				;

		mov dx, offset rslt			;printf("%s", rslt)
		outstr rslt

		outword bx 

		mov dx, offset ln			;printf("\n")
		outstr ln				;

		;----------------------------
		finish					;завершение работы приложения

	main endp
ends code
end main		;точка входа в программу
