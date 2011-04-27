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
	max dw ?
	min dw ?
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

		mov cx, n
		mov di, 0
		loop1:
			inint a[di]
			add di, 2
		loop loop1
		
		mov cx, n
		mov di, 0
		mov dx, a[di]
		mov bx, a[di]
		loop2:
			cmp dx, a[di]
			jge _dont_mov
				mov dx, a[di]
			_dont_mov:

			cmp bx, a[di]
			jle _dont_mov2
				mov bx, a[di]
			_dont_mov2:

			add di, 2
		loop loop2

		mov cx, n
		mov di, 0
		loop3:
			cmp dx, a[di]
			jne _dont_mov3
				mov a[di], bx
				jmp _continue
			_dont_mov3:

			cmp bx, a[di]
			jne _dont_mov4
				mov a[di], dx
				jmp _continue
			_dont_mov4:


			_continue:
			add di, 2
		loop loop3
				

		newline

		mov cx, n
		mov di, 0
		loop4:
			outint a[di]
			newline
			add di, 2
		loop loop4

		newline
		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
