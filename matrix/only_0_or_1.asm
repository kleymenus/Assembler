include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert m and n: $"
	s2 db "Insert matrix: $"
	s3 db "Strings, which containt only negative are more$"
	s4 db "Strings, which containt only positive are more$"
	s5 db "Count of positive and negative strigs are equal$"
	;---Variables---
	a dw 10 dup(10 dup(?))
	m dw ?
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
		newline
		inint m
		inint n
		
		mov dx, offset s2
		outstr
		newline
		mov ax, m
		mul n

		mov cx, ax
		mov di, 0
		loop1:
			inint a[di]
			add di, 2
		loop loop1

		; dl - флаг на отр. строки
		; dh - флаг на пол. строки
		; al - счетчик отр. строк
		; ah - счетчик пол. строк
		
		sub ax, ax

		mov cx, m
		sub bp, bp
		loop2:
			mov dl, 1
			mov dh, 1

			push cx
			mov cx, n
			sub di, di
			loop3:
				cmp a[bp][di], 0
				jl _dont_change_neg_fl
					mov dl, 0
				_dont_change_neg_fl:

				jg _dont_change_pos_fl
					mov dh, 0
				_dont_change_pos_fl:

				add di, 2
			loop loop3
			pop cx

			cmp dl, 1
			jne _dont_inc_neg_cntr
				inc al
			_dont_inc_neg_cntr:

			cmp dh, 1
			jne _dont_inc_pos_cntr
				inc ah
			_dont_inc_pos_cntr:

			add bp, n
			add bp, n
		loop loop2

		cmp al, ah
		je _equal
		jg _neg_more
		jl _pos_more
		_equal:
			mov dx, offset s5
			outstr
			jmp _exit
		_neg_more:
			mov dx, offset s3
			outstr
			jmp _exit
		_pos_more:
			mov dx, offset s4
			outstr
			jmp _exit
		_exit:

		


		

		newline
		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
