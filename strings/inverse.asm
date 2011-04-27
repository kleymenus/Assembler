include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	;---Variables---
	str1 db 100 dup(?) 
	str2 db 100 dup(?)
ends data

code segment
	assume ds:data, cs:code, ss:stk, es:data

	strlen proc
		;функция, определяет длину строки
		;использование
		;push <адрес строки>
		;call strlen
		;pop <результат>
		;|BP|AB|str1|...

		push bp
		mov bp, sp

		push di

		mov di, [bp+4]

		dec di			;это грязный хак
		_strlen_loop:			
			inc di			
			cmp [di], '$'	
		jne _strlen_loop

		sub di, [bp+4]	
		mov [bp+4], di

		pop di
		pop bp

		ret
	strlen endp

	scanf proc
		;процедура ввода строки
		;использование
		;push <адрес str1>
		;call scanf
		;BP|AB|str1|...
		
		push bp
		mov bp, sp

		push di
		push ax

		mov di, [bp+4]
		
		_scanf_loop:
			inch al
			mov [di], al
			inc di

			cmp al, '$'
		jne _scanf_loop
		mov al, '$'
		mov [di], al

		pop ax
		pop di
		pop bp

		ret 2
	scanf endp

	main proc				
		
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		mov es, ax
		;-------user code--------
		lea dx, str1
		push dx
		call scanf

		push dx
		call strlen
		pop cx

		sub cx, 2


		lea di, str2	;адрес начала str2

		lea si, str1	;
		add si, cx	;адрес концец str1

		inc cx
		loop1:
			mov al, [si]
			mov [di], al
			dec si
			inc di
		loop loop1

		mov [di], '$'

		lea dx, str2
		outstr
		newline

			
		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
