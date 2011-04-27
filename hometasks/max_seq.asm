include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert n: $"
	s2 db "Max number: $"
	s3 db "Index: $"
	;---Variables---
	n dw ?
	ind dw ?
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
		sub ax, ax
		
		mov dx, offset s1			;
		outstr					;ввод n
		inint n					;
		mov cx, n
		sub cx, 1
		sub dx, dx
		mov dx, 1

		inint bx
		mov ax, bx
		mov ind, dx
		inc dx
	_seq:
		inint bx	

		cmp bx, ax 
		jle _old_max
		mov ax, bx
		mov ind, dx
		_old_max:
		inc dx
	loop _seq
		newline
		mov dx, offset s2
		outstr
		outint ax

		newline
		mov dx, offset s3
		outstr
		outint ind

		newline


		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
