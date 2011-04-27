include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert string: $"
	;---Variables---
	str1 db 100 dup(?)
	n dw ?
ends data

code segment
	assume ds:data, cs:code, ss:stk, es:data

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

	main proc				
		
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		mov es, ax
		;-------user code--------
		lea dx, s1
		outstr
		newline

		lea dx, str1		;ввод строки
		push dx
		call scanf

		push dx			;получение длины строки
		call strlen
		pop n

		mov al, 'a'

		mov cx, n
		lea di, str1
		repne scas str1

		lea si, str1
		sub di, si
		outint di

		newline
		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
