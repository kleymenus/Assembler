include io.asm

info struc
	name db 32 dup('$')
	group dw 0
	course dw 0
	marks dw 0,0,0,0
info ends

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert N: $"
	s2 db "Name: $"
	s3 db "Group: $"
	s4 db "Course: $"
	s5 db "Marks: $"
	s6 db "With five: $"
	s7 db "With five and four: $" 
	s8 db "List to espulsion: $"
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

	readInfo proc
		lea dx, s2	;имя
		outstr
		push 31 
		lea dx, a[di].name
		push dx
		call readStr

		lea dx, s3	;группа
		outstr
		inint a[di].group

		lea dx, s4	;курс
		outstr
		inint a[di].course

		lea dx, s5	;оценки
		outstr
		inint a[di].marks[0]
		inint a[di].marks[2]
		inint a[di].marks[4]
		inint a[di].marks[6]

		ret
	readInfo endp

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
			call readInfo

			newline

			add di, type info
		loop loop1

		sub ax, ax	;кол-во отл
		sub bx, bx	;кол-во хор и отл

		mov cx, n
		sub di, di
		loop2:
			;счтитаем кол-во отличников
			mov dx, a[di].marks[0]
			add dx, a[di].marks[2]
			add dx, a[di].marks[4]
			add dx, a[di].marks[6]

			cmp dx, 20		;если в сумме 20, то это отличник
			jne _dont_inc_ax
				inc ax
			_dont_inc_ax:

			;считаем хорошистов и отличников
			cmp a[di].marks[0], 4
			jl _dont_inc_bx
			cmp a[di].marks[2], 4
			jl _dont_inc_bx
			cmp a[di].marks[4], 4
			jl _dont_inc_bx
			cmp a[di].marks[6], 4
			jl _dont_inc_bx
				inc bx
			_dont_inc_bx:

			add di, type info
		loop loop2

		sub bx, ax
		lea dx, s6
		outstr
		outint ax

		newline

		lea dx, s7
		outstr
		outint bx

		;список на отичсление
		newline
		lea dx, s8
		outstr

		mov cx, n
		sub di, di
		loop3:
			sub ax, ax	;кол-во двоек

			push cx

			mov cx, 4
			sub bx, bx
			loop4:
				cmp a[di].marks[bx], 2
				jne _dont_inc_ax_2
					inc ax
				_dont_inc_ax_2:

				add bx, 2
			loop loop4
			
			pop cx

			cmp ax, 3
			jl _dont_display
				lea dx, a[di].name	
				outstr
			_dont_display:

			add di, type info
		loop loop3

		;------------------------
		mov ax, 4c00h
		int 21h

	main endp
ends code


end main		;точка входа в программу
