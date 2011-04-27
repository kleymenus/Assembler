include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert N: $"
	s2 db "Insert elements: $"
	s3 db "Insert x: $"
	s4 db "Last element, which less of X: $"
	s5 db "Element is not exist$"
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
		mov dx, ax
		inc dx
		loop2:
			cmp a[bx], ax
			jge _dont_mov
				mov dx, a[bx]	
			_dont_mov:
			add bx, 2
		loop loop2
		inc ax
		cmp ax, dx
		jne _elem_exist
			mov dx, offset s5
			outstr
			jmp _brk
		_elem_exist:

		push dx
		mov dx, offset s4
		outstr
		pop dx
		outint dx
		
		_brk:
		newline
		
		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
