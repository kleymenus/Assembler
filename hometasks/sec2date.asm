include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert count of a seconds: $"
	s2 db "Count of hours: $"
	s3 db "Count of minutes: $"
	s4 db "Count of secods: $"
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
		mov dx, offset s1			;
		outstr					;ввод кол-ва секунд
		inint bx				;

		sub dx, dx				;
		mov ax, bx				; ax = bx div 60
		mov cx, 60				; bx - кол-во секунд
		div cx					;
		mov bx, dx				;

		mov dx, offset s4			; вывод кол-ва секунд
		outstr					;
		outword bx				;
		newline					;

		sub dx, dx				; ax - кол-во часов
		div cx					; bx - кол-во минут
		mov bx, dx				; 

		mov dx, offset s3			; вывод кол-ва минут
		outstr					;
		outword bx				;
		newline					;

		mov dx, offset s2			; вывод кол-ва часов
		outstr					;
		outword ax				;
		newline					;
		

		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
