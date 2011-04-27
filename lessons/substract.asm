include io.asm

stk segment stack 	;объявление сегмента стека
	db 100h dup(?)  ;выделяем память для стека
ends stk	

data segment					;объявление сегмента данных, объявление переменных
	x dw ?
	y dw ?
	inx db "Input x: $"
	iny db "Input y: $"
	outs db "Result: $"
	emptys db 13,10, "$"
ends data

code segment
	main proc				
		assume ds:data, cs:code, ss:stk		;сопоставление сегментам указанных регистров
		
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		
		mov dx, offset inx  
		outstr inx
		inint x					;вводим x
		mov dx, offset iny  
		outstr iny
		inint y					;вводим y

		mov ax, x
		sub ax, y
		
		mov dx, offset outs
		outstr outs
		outword ax
		
		mov dx, offset emptys
		outstr emptys

		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
