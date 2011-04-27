include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert N: $"
	s2 db "Insert array: $"
	s3 db "Minimal element, which has index - Fibonachi number: $"
	;---Variables---
	a dw 100 dup(?)
	n dw ?
ends data

code segment
	assume ds:data, cs:code, ss:stk

	is_fibonachi proc
		;проверка, принадлежит ли число последовательности Фибоначчи
		push bp
		mov bp, sp

		push ax
		push bx
		push cx

		mov ax, [bp+4]		;проверяемое число
		
		sub bx, bx
		sub cx, cx
		mov bx, 1		;предыдущее число
		mov cx, 1		;текущее число	
		_loop_is_fibonachi:
			push cx	
			add cx, bx
			pop bx

			cmp ax, bx
			je _is_fib

		cmp bx, ax
		jl _loop_is_fibonachi
			mov [bp+4], 0000h
			jmp _exit_is_fibonachi
		_is_fib:
			mov [bp+4], 0001h
		_exit_is_fibonachi:

		pop cx
		pop bx
		pop ax
		pop bp

		ret
	is_fibonachi endp

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
		newline
		
		mov cx, n
		mov di, 0
		mov dx, 0001h
		loop1:
			outint dx
			outch ':'
			outch ' ' 

			inint a[di]
			add di, 2
			
			inc dx
		loop loop1

		mov ax, a[0]
		mov cx,n
		mov di, 0
		mov dx, 0001h	;индекс
		loop2:
			cmp ax, a[di]
			jle _dont_mov
				push dx 
				call is_fibonachi
				pop bx

				cmp bx, 0
				je _dont_mov
					mov ax, a[di]
			_dont_mov:
			
			add di, 2
			inc dx
		loop loop2

		newline
		mov dx, offset s3
		outstr
		outint ax
		newline

		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
