include io.asm

info struc
	name db 16 dup('$')
	surname db 16 dup('$')
	class db 0,0
info ends

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert N: $"
	s2 db "Name: $"
	s3 db "Surname: $"
	s4 db "Class: $"
	s5 db "Insert surname for search: $"
	;---Variables---
	students info 10 dup(<>)
	search db 16 dup('$')
	n dw ?
ends data

code segment
	assume ds:data, cs:code, ss:stk, es:data

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

	strcmp proc
		;сравнивает строки
		;BP|AB|str1|str2|len
		push bp
		mov bp, sp

		push cx
		push si
		push di
		
		mov cx, [bp+8]
		mov si, [bp+4]
		mov di, [bp+6]

		repe cmpsb
		jcxz _equal
			mov [bp+8], 0000h
			jmp _brk_eq
		_equal:
			mov [bp+8], 0001h
		_brk_eq:
			
		pop di
		pop si
		pop cx
		pop bp

		ret 4
	strcmp endp

	main proc				
		
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		mov es, ax
		;-------user code--------
		lea dx, s1
		outstr
		inint n

		mov cx, n
		sub di, di
		loop1:
			lea dx, s2		;имя
			outstr
			push 15
			lea dx, students[di].name
			push dx
			call readStr

			lea dx, s3		;фамилия
			outstr
			push 15
			lea dx, students[di].surname
			push dx
			call readStr

			lea dx, s4
			outstr
			inch students[di].class[0]
			inch students[di].class[1]

			newline
			add di, type info
		loop loop1

		lea dx, s5
		outstr
		push 15
		lea dx, search
		push dx
		call readStr

		newline

		mov cx, n
		sub di, di
		loop2:
			push 15
			lea dx, search
			push dx
			lea dx, students[di].surname
			push dx
			call strcmp
			pop dx

			cmp dx, 0
			je _dont_display
				lea dx, students[di].name
				outstr
				lea dx, students[di].surname
				outstr
				outch students[di].class[0]
				outch students[di].class[1]
				newline
				newline
			_dont_display:

			add di, type info
		loop loop2

		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
