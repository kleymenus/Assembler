include io.asm

stk segment stack 	;объявление сегмента стека
	db 100h dup(?)  ;выделяем память для стека
ends stk	

data segment					;объявление сегмента данных, объявление переменных
	x db ?
	a db 36 
	b dw 19
	inx db "Input x: $"
	iny db "Input y: $"
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
		inint dx					;вводим x
		mov x, dl

		mov al, a
		mul x 
		add ax, b
		
		outword ax
		
		mov dx, offset emptys
		outstr emptys

		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
