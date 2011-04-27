include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Count different positon: $"
	;---Variables---
	str1 db "This is first string$"
	str2 db "Thes lr dirst strink$"
ends data

code segment
	assume ds:data, cs:code, ss:stk

	main proc				
		
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		;-------user code--------
		lea dx, str1
		outstr
		newline
		lea dx, str2
		outstr
		newline

		lea di, str1
		lea si, str2
		sub bx, bx
		loop1:
			mov al, [di]
			cmp [si], al
			je _dont_inc
				inc bx
			_dont_inc:

			inc di
			inc si

			cmp [si], '$'
		jne loop1

		lea dx, s1
		outstr
		outint bx
		newline


		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
