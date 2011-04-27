include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert n: $"
	s2 db "Insert matrix: $"
	s3 db "Max-min: $"
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

		;bx - максимум среди эл-тов выше гл. диаг
		;dx - минимум среди эл-тов ниже гл. диаг
		;i - строковой индекс
		;j - столбцовый индекс

		mov bx, a+2 	;a[1][2]
		mov di, n
		add di, n
		mov dx, a[di] 	;a[2][1]

		newline

		mov i, 0001h
		mov cx, n
		sub bp, bp
		loop2:
			mov j, 0001h
			push cx
			mov cx, n
			sub di, di
			loop3:
				mov ax, j
				cmp i, ax
				jge _not_above_diag
					cmp bx, a[bp][di]	
					jge _dont_mov1
						mov bx, a[bp][di]
					_dont_mov1:
				_not_above_diag:

				cmp i, ax
				jle _not_below_diag
					cmp dx, a[bp][di]
					jle _dont_mov2
						mov dx, a[bp][di]
					_dont_mov2:
				_not_below_diag:

				add di, 2
				inc j
			loop loop3
			pop cx


			add bp, n
			add bp, n

			inc i
		loop loop2

		sub bx, dx

		mov dx, offset s3
		outstr
		outint bx
		newline

		;------------------------

		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
