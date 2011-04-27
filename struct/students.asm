include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

info struc
	nm db 32 dup('$')
	grp dw 0
	crs dw 0
	balls dw 0,0,0
info ends

data segment
	;---Constants---
	s1 db "Insert N: $"
	s2 db "Insert name: $"
	s3 db "Insert group: $"
	s4 db "Insert course: $"
	s5 db "Insert balls: $"
	s6 db "Name",09h,"Group",09h,"Course$"
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
		newline

		mov cx, n
		sub di, di
		loop1:
			lea dx, s2		;воод имени
			outstr
			push 31
			lea dx, a[di].nm
			push dx
			call readStr

			lea dx, s3		;ввод группы
			outstr
			inint a[di].grp

			lea dx, s4		;курс
			outstr
			inint a[di].crs

			lea dx, s5		;оценки
			outstr
			inint a[di].balls[0]
			inint a[di].balls[1]
			inint a[di].balls[2]

			newline

			add di, type info
		loop loop1

		lea dx, s6
		outstr
		newline

		mov cx,n 
		sub di, di
		loop2:
			mov ax, a[di].balls[0]
			add ax, a[di].balls[1]
			add ax, a[di].balls[2]

			cmp al, 6
			jg _dont_display
				lea dx, a[di].nm
				outstr
				outch 09h

				outint a[di].grp
				outch 09h

				outint a[di].crs
				outch 09h

				newline
			_dont_display:

			add di, type info
		loop loop2


		;------------------------
		finish					;завершение работы приложения

	main endp
ends code

end main		;точка входа в программу
