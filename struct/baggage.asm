include io.asm

info struc
	surname db 16 dup('$')
	count dw 0
	weight dw 0
info ends

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert N: $"
	s2 db "Surname: $"
	s3 db "Count: $"
	s4 db "Weight: $"
	;---Variables---
	a info 10 dup(<>)
	n dw ?
ends data

code segment
	assume ds:data, cs:code, ss:stk

	readStr proc
		;процедура для чтения строки
		;использование:
		;push maxlen
		;push addr
		;call readStr
		
		;BP|AB|str|len|...

		push bp
		mov bp, sp
		
		push ax
		push bx
		push cx
		push dx

		mov ah, 3fh
		sub bx, bx
		mov cx, [bp+6]
		mov dx, [bp+4]
		int 21h

		pop dx
		pop cx
		pop bx
		pop ax
		pop bp

		ret 4
	readStr endp

	main proc				
		
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		;-------user code--------
		lea dx, s1
		outstr
		inint n

		mov cx, n
		sub di, di
		loop1:
			lea dx, s2	;фамилия
			outstr
			push 15
			lea dx, a[di].surname
			push dx
			call readStr

			lea dx, s3	;кол-во
			outstr
			inint a[di].count

			lea dx, s4	;вес
			outstr
			inint a[di].weight

			newline

			add di, type info
		loop loop1

		newline

		mov cx, n
		sub di, di
		loop2:
			cmp a[di].count, 1
			jne _dont_display

			cmp a[di].weight, 30
			jle _dont_display
				lea dx, a[di].surname
				outstr
			_dont_display:

			add di, type info
		loop loop2

		newline
		;------------------------
		mov ax, 4c00h
		int 21h

	main endp
ends code


end main		;точка входа в программу
