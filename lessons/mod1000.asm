include io.asm

stk segment stack 	;объявление сегмента стека
	db 100h dup(?)  ;выделяем память для стека
ends stk	

data segment					;объявление сегмента данных, объявление переменных
	s1 db "Insert x: $"
	ln db 13,10,"$"
	x dw 1000
ends data

code segment
	main proc				
		assume ds:data, cs:code, ss:stk		;сопоставление сегментам указанных регистров
		
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		
		mov dx,	 offset s1			;printf(s1)
		outstr s1				;

		sub dx,dx
		inint ax
		div x
		mov bx,dx

		mov dx,	 offset ln			;printf(ln)
		outstr ln				;

		outint bx 

		mov dx,	 offset ln			;printf(ln)
		outstr ln				;
		
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
