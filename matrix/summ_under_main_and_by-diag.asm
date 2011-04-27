include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert n: $"
	s2 db "Insert matrix: $"
	s3 db "Summ element under main and by-diag: $"
	;---Variables---
	a dw 10 dup(10 dup(?))
	n dw ?
	i dw ?
	j dw ?
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
		mov dx, offset s1
		outstr
		newline
		inint n
		
		mov dx, offset s2
		outstr
		newline
		mov ax, n
		mul n

		mov cx, ax
		mov di, 0
		loop1:
			inint a[di]
			add di, 2
		loop loop1

		;bx - сумма
		;i - строковой индекс
		;j - столбцовый индекс

		newline

		mov cx, n
		sub bp, bp

		mov i, 0001h
		sub bx, bx
		loop2:
			push cx
			mov cx, n
			mov j, 0001h
			sub di, di
			loop3:
				mov ax, i		
				cmp ax, j
				jle _dont_add
				
				mov ax, n
				sub ax, j
				inc ax
				cmp i, ax
				jle _dont_add
					add bx, a[bp][di]
				_dont_add:

				add di, 2
				inc j
			loop loop3
			pop cx


			add bp, n
			add bp, n

			inc i
		loop loop2

		newline

		mov dx, offset s3
		outstr
		outint bx

		newline

		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
