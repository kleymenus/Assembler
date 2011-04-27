include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert N: $"
	s2 db "Insert array: $"
	s3 db "Average: $"
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

		sub ax,ax
		mov cx, n
		mov di, 0
		loop2:
			add ax, a[di]
			add di, 2
		loop loop2
		sub dx, dx
		mov bx, n
		div bx
			
		newline
		mov dx, offset s3
		outstr
		outint ax	

		newline
			

		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
