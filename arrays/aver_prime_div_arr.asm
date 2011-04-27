include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert N: $"
	s2 db "Insert array: $"
	s3 db "Average value of prime numbers, which has index not divisible 3: $"
	;---Variables---
	n dw ?
	a dw 10 dup(?)
	summ dw 0
	cnt dw 0
ends data

code segment
	assume ds:data, cs:code, ss:stk

	isprime proc
		;bx - входное число		
		;dx = 1, если bx - простое, иначе 0
		push cx
		push ax
		sub dx, dx

		mov cx, bx
		sub cx, 2

		mov dl, 2
		loop_pr:
			mov ax, bx	
			div dl
			cmp ah, 0
			je _not_prime
		loop loop_pr
			mov dx, 1
			jmp _brk
		_not_prime:
			sub dx, dx
		_brk:

		pop ax
		pop cx

		ret
	isprime endp

	main proc				
		
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		;-------user code--------
		sub bx, bx

		mov dx, offset s1
		outstr
		inint n

		mov dx, offset s2
		outstr
		newline

		mov cx, n
		mov di, 0
		loop1:
			inint a[di]
			add di, 2
		loop loop1

		mov cx, n
		mov di, 0
		loop2:
			mov bx, di				
			call isprime
			cmp dx, 0
			jne _skip

			mov ax, a[di]
			sub dx, dx
			mov bx, 3
			div bx
			cmp dx, 0
			je _skip
				inc cnt
				mov ax, a[di]
				add summ, ax
			_skip:

			add di, 2
		loop loop2
		
		mov ax, summ
		sub dx, dx
		div cnt

		mov dx, offset s3
		outstr
		outint ax

		newline

		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
