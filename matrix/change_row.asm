include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert m and n: $"
	s2 db "Insert matrix: $"
	s3 db "Insert k and l: $"
	s4 db "Output matrix: $"
	;---Variables---
	a dw 10 dup(10 dup(?))
	m dw ?
	n dw ?
	k dw ?
	l dw ?
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

		newline

		mov dx, offset s3
		outstr
		newline
		inint k
		inint l

		mov ax, k
		dec ax
		mul n
		mov bx, ax
		add bx, ax

		mov ax, l
		dec ax
		mul n
		mov bp, ax
		add bp, ax

		mov cx, n
		sub di, di

		loop2:
			push a[bx][di]
			push a[bp][di]

			pop a[bx][di]
			pop a[bp][di]

			add di, 2
		loop loop2

		newline
		mov dx, offset s4
		outstr
		newline

		mov cx, m
		sub bp, bp
		loop6:
			push cx
			mov cx, n
			sub di, di
			loop7:
				outint a[bp][di]
				outch ' ' 
				add di, 2
			loop loop7
			pop cx

			newline
			add bp, n
			add bp, n
		loop loop6


		

		newline
		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
