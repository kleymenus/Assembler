include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert m and n: $"
	s2 db "Insert matrix: $"
	s3 db "Column with max element: $"
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

		;ax - столбец с макс. элементом
		;bx - макс. элемент

		mov bx, a[0]

		mov cx, m
		sub bp, bp
		loop2:
			push cx
			mov cx, n
			sub di, di
			loop3:
				cmp bx, a[bp][di]
				jge _dont_mov
					mov bx, a[bp][di]
					mov ax, di
				_dont_mov:

				add di, 2
			loop loop3
			pop cx

			add bp, n
			add bp, n
		loop loop2

		newline

		mov cx, m
		sub bp, bp

		push ax
		pop di
		loop4:
			outint a[bp][di]
			newline

			add bp, n
			add bp, n
		loop loop4
			

		newline
		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
