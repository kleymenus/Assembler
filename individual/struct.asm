include io.asm

book struc
	name db 32 dup('$')
	author db 16 dup('$')
	cost dw ?
	year dw ?
	pages dw ?
book ends

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Name: $"
	s2 db "Author: $"
	s3 db "Cost: $"
	s4 db "Year: $"
	s5 db "Pages: $"
	s6 db "Insert N: $"
	;---Variables---
	a book 30 dup(<>)
	n dw ?
ends data

code segment
	assume ds:data, cs:code, ss:stk

	readStr proc
		;процедура для чтения строки
		;использование:
		;push maxlen
		;push addr
		;call readStr
		
		;BP|AB|str|len|...

		push bp
		mov bp, sp
		
		push ax
		push bx
		push cx
		push dx

		mov ah, 3fh
		sub bx, bx
		mov cx, [bp+6]
		mov dx, [bp+4]
		int 21h

		pop dx
		pop cx
		pop bx
		pop ax
		pop bp

		ret 4
	readStr endp

	isLeap proc
		;функция проверки года на високосность
		;использование:
		;push <year>
		;call isLeap
		;pop result

		;BP|AB|year|

		push bp
		mov bp, sp

		push ax
		push bx
		push dx

		sub bx, bx

		sub dx, dx
		mov ax, [bp+4]
		mov bx, 400
		div bx
		cmp dx, 0
		je _leap

		sub dx, dx
		mov ax, [bp+4]
		mov bx, 100
		div bx
		cmp dx, 0
		je _nleap

		sub dx, dx
		mov ax, [bp+4]
		mov bx, 4
		div bx
		cmp dx, 0
		je _leap

		jmp _nleap

		_leap:
			mov [bp+4], 0001h 	
			jmp _brk_leap
		_nleap:
			mov [bp+4], 0000h
		_brk_leap:

		pop dx
		pop bx
		pop ax
		pop bp

		ret
	isLeap endp

	isPrime proc
		;функция проверки числа на простоту
		;использование
		;push <numb>
		;call isPrime
		;pop <result>

		;BP|AB|numb|...
		
		push bp
		mov bp, sp

		push ax
		push bx
		push cx

		sub bl, bl

		mov cx, [bp+4]
		sub cx, 2

		loop_pr:
			mov ax, [bp+4]
			mov bl, cl
			inc bl
			div bl
			cmp ah, 0
			je _not_prime
		loop loop_pr
			mov [bp+4], 0001h		
			jmp _brk_pr
		_not_prime:
			mov [bp+4], 0000h
		_brk_pr:

		pop cx
		pop bx
		pop ax
		pop bp

		ret
	isPrime endp

	main proc				
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		;-------user code--------
		lea dx, s6	;чтение кол-ва структур
		outstr
		inint n
		newline

		mov cx, n
		sub di, di
		loop1:
			lea dx, s1	;ввод названия
			outstr
			lea dx, a[di].name 
			push 31
			push dx
			call readStr

			lea dx, s2	;ввод имени автора
			outstr
			lea dx, a[di].author
			push 15
			push dx
			call readStr

			lea dx, s3	;цена
			outstr
			inint a[di].cost

			lea dx, s4	;год
			outstr
			inint a[di].year

			lea dx, s5	;кол-во страниц
			outstr
			inint a[di].pages

			add di, type book

			newline
		loop loop1

		mov cx, n	
		sub di, di
		loop2:
			push a[di].year
			call isLeap
			pop dx

			cmp dx, 0
			je _dont_display

			push a[di].pages
			call isPrime
			pop dx

			cmp dx, 0
			je _dont_display
				lea dx, a[di].author	
				outstr
				newline
			_dont_display:

			add di, type book
		loop loop2

		newline
		;------------------------
		finish					;завершение работы приложения
	main endp
ends code


end main		;точка входа в программу
