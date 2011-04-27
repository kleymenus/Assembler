include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert n: $"
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
		
		mov dx, offset s1			;
		outstr					;ввод n
		inint cx				;

	loop1:
		outint cx
		newline
		loop loop1


		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
