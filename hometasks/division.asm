include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert a: $"
	s2 db "Insert b: $"
	s3 db "A % B = 0 or B % A = 0$"
	s4 db "A % B != 0 and B % A != 0$"
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
		outstr					;ввод a
		inint bx				;

		mov dx, offset s2			;
		outstr					;ввод b
		inint cx				;

		sub dx, dx				;
		mov ax, bx				;dx = a % b
		idiv cx					;

		cmp dx, 0
		je _a_b

		sub dx, dx				;
		mov ax, cx				;dx = b % a
		idiv bx					;

		cmp dx, 0
		je _a_b

		jmp _else

	_a_b:						;если a % b =0 или b % a = 0
		mov dx, offset s3			;то выводим соответствующее сообщение
		outstr
		jmp _break
	_else:						;иначе
		mov dx, offset s4			;выводим что числа не делятся друг другом
		outstr
		jmp _break
	_break:
		newline


		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
