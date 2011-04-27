include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert N: $"
	s2 db "Insert array: $"
	;---Variables---
	n dw ?
	a dw 10 dup(?)
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
		sub bx, bx

		mov dx, offset s1
		outstr
		inint n

		mov dx, offset s2
		outstr
		newline

		mov cx, n
		mov di, 0
		loop1:
			inint a[di]
			add di, 2
		loop loop1

		sub dx, dx
		mov ax, n
		mov bx, 2
		div bx
		mov cx, ax

		mov ax, n
		mul bx

		mov si, 0
		mov di, ax	;di = 2*n
		sub di, 2
		loop2:
			sub ax,ax
			sub dx,dx

			mov ax, a[si]
			mov dx, a[di]
			mov a[di], ax
			mov a[si], dx

			add si, 2
			sub di, 2
		loop loop2

		newline

		mov cx, n
		mov di, 0
		loop3:
			outint a[di]
			add di, 2
		loop loop3

		newline
			

		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
