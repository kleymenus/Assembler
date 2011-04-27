include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert x: $"
	s2 db "Insert y: $"
	s3 db "Result: $"
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
		mov dx, offset s1			;printf(s1)
		outstr					;
		inint ax				;ввод первого числа 

		mov dx, offset s2			;printf(s2)
		outstr					;
		inint x					;ввод второго числа

		add ax, x				;ax=ax+x

		sub dx,dx
		mov bx, 2				;ax = ax/2
		div bx					;

		newline					;printf("\n")
		mov dx, offset s3			;printf(s3)
		outstr					;

		outint ax

		newline					;printf("\n")
		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
