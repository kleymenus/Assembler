include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert n: $"
	s2 db "Insert sequnce: $"
	s3 db "Summ n*x1+(n-1)*x2+...+xn: $"
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
		sub cx, cx				;
		
		mov dx, offset s1			;
		outstr					;ввод n
		inint cx				;

		sub bx, bx				; bx - сумма

		mov dx, offset s2
		outstr
		newline
	_seq:
		inint ax
		mul cx		;ax = ax*cx
		add bx, ax	;bx += ax
	loop _seq
		
		newline
		mov dx, offset s3
		outstr
		outint bx
		newline

		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
