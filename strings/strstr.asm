include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "First occurence str2 in str1: $"
	s2 db "str2 not occurence in str1$"
	s3 db "Insert str1: $"
	s4 db "Insert str2: $"

	;---Variables---
	str1 db 100 dup(?)
	str2 db 100 dup(?)
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

	isEqual proc
		;процедура проверят на равенство строки str1 и str2 длины n
		;использование:
		;push (длина строк>
		;push (адрес str1>
		;push <адрес str2>
		;call isEqual
		;pop <результат>

		;|BP|АВ|str2|str1|n|...
		push bp
		mov bp, sp

		push cx
		push di
		push si

		mov cx, [BP+8]
		mov di, [BP+6]
		mov si, [BP+4]
		cld
		repe cmpsb
		jcxz _isEqual_true
			mov [BP+8], 0000h
			jmp _isEqual_break
		_isEqual_true:
			mov [BP+8], 0001h	
		_isEqual_break:

		pop si
		pop di
		pop cx
		pop bp

		ret 4
	isEqual endp

	main proc				
		
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		mov es, ax
		;-------user code--------
		lea dx, s3
		outstr
		newline
		lea dx, str1		;ввод строки str1
		push dx
		call scanf

		push dx			;длина str1
		call strlen
		pop cx

		lea dx, s4
		outstr
		newline
		lea dx, str2		;ввод строки str2
		push dx
		call scanf

		push dx			;длина str2
		call strlen
		pop ax
		newline


		lea di, str1
		lea si, str2

		sub cx, ax
		loop1:
			push ax
			push di
			push si
			call isEqual
			pop dx

			cmp dx, 1
			je _str2_in_str1

			inc di	
		loop loop1
			;нет вхождений 
			lea dx, s2
			outstr
			jmp _break
		_str2_in_str1:
			lea dx, s1
			outstr

			lea si, str1
			sub di, si
			inc di
			outint di
		_break:

		newline

		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
