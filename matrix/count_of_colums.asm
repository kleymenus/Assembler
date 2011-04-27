include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert m and n: $"
	s2 db "Insert matrix: $"
	s3 db "Count colums, which has more 2 negative elements: $"
	;---Variables---
	a dw 10 dup(10 dup(?))
	m dw ?
	n dw ?
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
		inint m
		inint n
		
		mov dx, offset s2
		outstr
		newline
		sub dx, dx	
		mov ax, m
		mul n
		
		mov cx, ax
		mov di, 0
		loop1:
			inint a[di]
			add di, 2
		loop loop1


		;ax - кол-во отрицательных в данном столбце
		;bx - кол-во искомых столбцов
		
		sub bx, bx

		mov cx, m
		sub di, di
		loop2:
			sub ax, ax
			
			push cx
			mov cx, n
			sub bp, bp
			loop3:
				cmp a[bp][di], 0
				jge _dont_inc
					inc ax
				_dont_inc:
				
				add bp, n
				add bp, n
			loop loop3
			pop cx

			cmp ax, 2
			jle _dont_inc2
				inc bx
			_dont_inc2:

			add di, 2
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
