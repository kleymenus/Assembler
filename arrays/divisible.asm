include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert N: $"
	s2 db "Insert M1 and M2: $"
	s3 db "Insert array: $"
	s4 db "Result: $"
	;---Variables---
	a dw 10 dup(?)
	n dw ?
	m1 dw ?
	m2 dw ?
ends data

code segment
	assume ds:data, cs:code, ss:stk

	divisible proc
		;ax - проверяемое число
		;bx и cx - делители
		;результат процедуры в dx
		push ax
		sub dx, dx
		div bx
		cmp dx, 0
		jne _not_div

		pop ax
		sub dx, dx
		div cx
		cmp dx, 0
		jne _not_div
			sub dx, dx
			mov dx, 1
			jmp _exit
		_not_div:
			sub dx, dx
		_exit:
			
		ret
	divisible endp

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
		inint m1
		inint m2

		mov dx, offset s3
		outstr
		newline

		mov cx, n
		sub bx, bx
		loop1:
			inint a[bx]
			add bx, 2
		loop loop1

		mov cx, n
		sub bx, bx
		loop2:
			push bx
			push cx
			mov ax, a[bx]
			mov bx, m1
			mov cx, m2
			call divisible
			pop cx
			pop bx

			cmp dx, 1
			je _outelem

			add bx, 2
		loop loop2
		jmp _brk1

		_outelem:
			newline
			mov dx, offset s4
			outstr
			outint a[bx]
		_brk1:
		newline

		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
