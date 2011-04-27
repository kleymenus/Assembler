include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert N: $"
	s2 db "Insert first matrix: $"
	s3 db "Insert second matrix: $"
	;---Variables---
	n dw ?
	a dw 10 dup(10 dup(?))
	b dw 10 dup(10 dup(?))
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

		newline

		mov dx, offset s3
		outstr
		newline

		mov cx, ax
		mov di, 0
		loop2:
			inint b[di]
			add di, 2
		loop loop2

		newline
		newline
		;ax - счетчик пол. эл-тов
		;bp, di - индексные регистры матриц A и B

		mov cx, n
		sub bp, bp
		loop3:
			sub ax, ax	;обнуляем счетчик

			push cx
			mov cx, n
			sub di, di
			loop4:
				cmp a[bp][di], 0
				jle _dont_inc_cntr1
					inc ax
				_dont_inc_cntr1:

				cmp b[bp][di], 0
				jle _dont_inc_cntr2
					inc ax
				_dont_inc_cntr2:

				add di, 2
			loop loop4
			pop cx

			cmp ax, 3	;проверяем счетчик
			jg _print_zero
				outch '1'
				jmp _break
			_print_zero:
				outch '0'
			_break:

			add bp, n
			add bp, n
		loop loop3

		newline
		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
