include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert a: $"
	s2 db "Insert b: $"
	s3 db "Insert c: $"
	s4 db "Real$"
	s5 db "Not real$"
	;---Variables---
	a dw ?
	b dw ?
	c dw ?
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
		mov dx, offset s1		;
		outstr				;ввод a
		inint a				;

		mov dx, offset s2		;
		outstr				;ввод b
		inint b				;

		mov dx, offset s3		;
		outstr				;ввод c
		inint c				;

		mov ax, b			;ax = b^2
		imul b 

		mov bx, ax			;bx = дескриминант

		mov ax, -4			;
		imul a				;ax = -4*a*c
		imul c				;

		add bx, ax

		cmp bx, 0
		jge bx_0
		jmp _else
	
	bx_0:					;bx>=0
		mov dx, offset s4
		outstr
		jmp _break
	_else:
		mov dx, offset s5
		outstr
		jmp _break
	_break:
		newline
		
		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
