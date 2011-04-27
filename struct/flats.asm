include io.asm

info struc
	cnt dw 0
	addr db 32 dup('$')
	reg db 4 dup('$')
	pay dw 0	
info ends

stk segment stack 
	db 100h dup(?)
stk ends

data segment
	;---Constants---
	s1 db "Insert N: $"
	s2 db "Count of rooms: $"
	s3 db "Address: $"
	s4 db "Region: $"
	s5 db "Pay in month: $"
	;---Variables---
	a info 10 dup(<>)
	n dw ?
	myreg db "CMR$"
data ends

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
		newline

		sub ax, ax

		mov cx, n
		sub di, di
		loop1:
			lea dx, s2	;кол-во комнат
			outstr
			inint a[di].cnt

			lea dx, s3	;адресс
			outstr
			push 31
			lea dx, a[di].addr
			push dx
			call readStr

			lea dx, s4	;регион
			outstr
			push 3
			lea dx, a[di].reg
			push dx
			call readStr
			newline

			lea dx, s5	;аренда
			outstr
			inint a[di].pay

			add ax, a[di].pay	;считаем сумму арендных плат

			newline

			add di, type info
		loop loop1

		sub dx, dx
		div n
		;ax - средняя аренда

		mov cx, n
		sub di, di
		loop2:
			push 4			;сравнение
			lea dx, a[di].reg
			push dx
			lea dx, myreg
			push dx
			call strcmp
			pop dx

			cmp dx, 1
			jne _dont_display

			cmp a[di].pay, ax
			jle _dont_display
				lea dx, a[di].addr
				outstr
			_dont_display:
			
			add di, type info
		loop loop2
	
		newline
		;------------------------
		mov ax, 4c00h				;завершение работы приложения
		int 21h

	main endp
code ends


end main		;точка входа в программу
