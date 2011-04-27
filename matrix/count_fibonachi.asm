include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert n: $"
	s2 db "Insert matrix: $"
	s3 db "Count of Fibbonachi number above main diag: $"
	;---Variables---
	a dw 10 dup(10 dup(?))
	n dw ?
	i dw ?
	j dw ?
ends data

code segment
	assume ds:data, cs:code, ss:stk

	is_fibonachi proc
		;проверка, принадлежит ли число последовательности Фибоначчи
		push bp
		mov bp, sp

		push ax
		push bx
		push cx

		mov ax, [bp+4]		;проверяемое число
		
		sub bx, bx
		sub cx, cx
		mov bx, 1		;предыдущее число
		mov cx, 1		;текущее число	
		_loop_is_fibonachi:
			push cx	
			add cx, bx
			pop bx

			cmp ax, bx
			je _is_fib

		cmp bx, ax
		jl _loop_is_fibonachi
			mov [bp+4], 0000h
			jmp _exit_is_fibonachi
		_is_fib:
			mov [bp+4], 0001h
		_exit_is_fibonachi:

		pop cx
		pop bx
		pop ax
		pop bp

		ret
	is_fibonachi endp

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

		newline

		;bx - счетчик

		sub bx, bx
		
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
					push a[bp][di]
					call is_fibonachi
					pop dx

					add bx, dx
				_not_above_diag:

				add di, 2
				inc j
			loop loop3
			pop cx

			add bp, n
			add bp, n

			inc i
		loop loop2

		mov dx, offset s3
		outstr
		outint bx

		newline
		;------------------------

		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
