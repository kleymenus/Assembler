include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "This programm calculate expression (max(a,a+b)+max(a,b+c))/(1+max(a+b*c,3))$"
	s2 db "Insert a: $"
	s3 db "Insert b: $"
	s4 db "Insert c: $"
	s5 db "Result: $"
	;---Variables---
	a dw ?
	b dw ?
	c dw ?
ends data

code segment
	assume ds:data, cs:code, ss:stk

	max proc
		;функция, на входе ax, bx
		;помещает в dx max(ax,bx)
		cmp ax, bx
		jg _ax_max
			mov dx, bx
			jmp _brk
		_ax_max:
			mov dx, ax
		_brk:
		ret
	max endp
	
	main proc				
		
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		;-------user code--------
		sub ax,ax
		sub bx,bx

		mov dx, offset s1
		outstr
		newline

		mov dx, offset s2
		outstr
		inint a

		mov dx, offset s3
		outstr
		inint b

		mov dx, offset s4
		outstr
		inint c


		mov ax, a		;сохранение max(a,a+b)
		mov bx, a
		add bx, b
		call max
		push dx

		mov ax, a	
		mov bx, b
		add bx, c
		call max

		pop ax			;ax = max(a,a+b)
		add dx, ax
		push dx			;сохранение max(a,a+b)+max(a,b+c)

		mov ax, b		;ax = b*c+a
		imul c
		add ax, a
		mov bx, 3
		call max
		add dx, 1		;dx = max(b*c+a,3)+1

		pop ax
		mov bx, dx
		sub dx, dx
		idiv bx

		mov dx, offset s5
		outstr
		outint ax
		newline
		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
