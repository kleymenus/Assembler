include io.asm

info struc
	domen db 16 dup('$')
	count dw 0
	theme db 16 dup('$')
info ends

stk segment stack 
	db 100h dup(?)
stk ends

data segment
	;---Constants---
	s1 db "Insert N: $"
	s2 db "Domen name: $"
	s3 db "Count of visitors: $"
	s4 db "Theme: $"
	tm db "Computers$$"
	;---Variables---
	a info 10 dup(<>)
	n dw ?
data ends

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

		mov bx, [bp+4]	;удаление 13,10
		add bx, ax
		mov [bx-2], '$'
		mov [bx-1], '$'

		pop dx
		pop cx
		pop bx
		pop ax
		pop bp

		ret 4
	readStr endp

	outInfo proc
		lea dx, a[di].domen
		outstr
		outch 09
		
		outint a[di].count
		outch 09

		lea dx, a[di].theme
		outstr
		outch 09

		newline

		ret
	outInfo endp

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
			lea  dx, s2	;домен
			outstr
			push 15
			lea dx, a[di].domen
			push dx
			call readStr

			lea dx, s3
			outstr
			inint a[di].count

			lea dx, s4
			outstr
			push 15
			lea dx, a[di].theme
			push dx
			call readStr

			newline 

			add di, type info
		loop loop1

		newline

		mov cx, n
		sub di, di
		loop2:
			lea si, a[di].domen		;проверка домена
			loop3:
				inc si
				cmp [si], '$'
			jne loop3
			
			mov al, 'u'
			cmp [si-2], al
			jne _dont_display
			mov al, 'r'
			cmp [si-3], al
			jne _dont_display
			mov al, '.'
			cmp [si-4], al
			jne _dont_display

			cmp a[di].count, 1000		;проверка посещяемостии
			jle _dont_display


			push di
			lea si, a[di].theme		;проверка темы
			lea di, tm
			loop4:
				mov ax, [si]
				cmp ax, [di]
				jne _dont_display

				inc si
				inc di
			cmp [si], '$'
			jne loop4
				pop di
				call outInfo
			_dont_display:

			pop di
			add di, type info
		loop loop2

		;------------------------
		mov ax, 4c00h
		int 21h

	main endp
code ends


end main		;точка входа в программу
