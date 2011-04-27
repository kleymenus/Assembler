include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
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
		
		mov cx, 26
		mov bl, "a"
	loop1:
		outch bl	
		outch " "
		add bl, 1
	loop loop1
		newline


		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
