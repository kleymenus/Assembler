include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	;---Variables---
	char db ?
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
		mov char, 49

		mov cx, 42
		loop1:
			sub dx, dx

			mov ax, cx
			mul cx
			sub ax, cx
			
			mov bx, 2
			div bx


			cmp dx, 0
			jne _not_out_ch
				outch char
				inc ax
				jmp _brk
			_not_out_ch:
				outch ' '
			_brk:

			mov cx, ax

		jmp loop1

		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
