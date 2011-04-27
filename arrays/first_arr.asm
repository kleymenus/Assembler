include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert N: $"
	s2 db "Insert elements: $"
	s3 db "Insert x: $"
	s4 db "First element, which less of X: $"
	;---Variables---
	a dw 10 dup(?)
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
		inint n

		mov dx, offset s3
		outstr
		inint ax 

		mov dx, offset s2
		outstr
		newline

		mov cx, n
		mov bx, 0
		loop1:
			inint a[bx]
			add bx, 2 
		loop loop1

		mov cx, n
		mov bx, 0
		loop2:
			cmp a[bx], ax
			jl _brk
			add bx, 2
		loop loop2
		jmp _brk2

		_brk:
			mov dx, offset s4
			outstr
			outint a[bx]
		_brk2:
		
		newline
		
		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
