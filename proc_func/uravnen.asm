include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert a, b, c: $"
	s2 db "Yes.$"
	s3 db "No.$"
	;---Variables---
	a dw ?
	b dw ?
	c dw ?
ends data

code segment
	assume ds:data, cs:code, ss:stk

	isreal proc
		push bp
		mov bp, sp
		
		push ax
		push bx
		push cx

		mov bx, [bp+4]  ;a
		mov ax, [bp+6]  ;b
		mov cx, [bp+8]	;c

		mul ax

		sub dx, dx
		add dx, ax
		push dx

		mov  ax, cx
		imul bx
		mov bx, -4
		imul bx

		pop dx
		add dx, ax

		cmp dx, 0
		jl _not_real
			mov dx, offset s2
			outstr
			jmp _brk
		_not_real:
			mov dx, offset s3
			outstr
		_brk:

		pop cx
		pop bx
		pop ax
		pop bp

		ret 6
	isreal endp
	
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
		inint a
		inint b
		inint c

		push c
		push b
		push a
		call isreal

		push b
		push a
		push c
		call isreal

		push a
		push c
		push b
		call isreal

		newline

		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
