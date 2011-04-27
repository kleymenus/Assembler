include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
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
		sub cx, cx
		sub bx, bx
		
	mov cx, 0
	loop1:
		add cx, 1

		mov bx, 0 
		loop2:
			add bx, 1
			
			mov ax, cx
			mul bx

			cmp ax, 10
			jge _not_print_null
			outch "0"
			_not_print_null:
				outint ax	

			sub ax,ax
			outch " "

			cmp bx, 9 
		jne loop2
		newline

		cmp cx, 9
	jne loop1
		newline

		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
