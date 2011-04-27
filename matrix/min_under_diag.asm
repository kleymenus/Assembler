include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert n: $"
	s2 db "Insert matrix: $"
	s3 db "Minimal element under by-diag: $"
	;---Variables---
	a dw 10 dup(10 dup(?))
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


		mov dx, 1
			
		mov cx, n
		sub cx, 1

		mov bp, ax
		add bp, ax
		sub bp, 2
		mov bx, a[bp]	; bx= a[n][n]

		sub bp, bp
		add bp, n
		add bp, n
		loop2:
			push cx
			mov cx, dx

			mov ax, n
			sub ax, dx

			push bx
			mov bx, 2
			push dx	
			mul bx
			pop dx
			pop bx

			mov di, ax
			loop3:
				cmp a[bp][di], bx
				jge _dont_mov
					mov bx, a[bp][di]
				_dont_mov:

				add di, 2
			loop loop3
			pop cx

			inc dx

			add bp, n
			add bp, n
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
