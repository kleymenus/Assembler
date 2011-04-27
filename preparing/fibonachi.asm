include io.asm

stk segment stack 
	db 100h dup(?)
stk ends

data segment
	;---Constants---
	;---Variables---
data ends

code segment
	assume ds:data, cs:code, ss:stk

	fib proc
		;вычисление f(n). n будем передавать регистром al
		;вычисленное значение будет храниться в bx

		cmp al, 2
		ja _recursion
			;не рекурсивная часть
			mov bx, 1
			ret
		_recursion:
			;рекурсивная часть
			push ax

			dec ax		;
			call fib	;	сохрагяем fib(n-1)
			push bx		;
			
			dec ax
			call fib	; bx = fib(n-2)

			pop ax		; ax = fin(n-1)
			add bx, ax	; bx = fib(n-2)+fib(n-1)

			pop ax		;восстанавливаем ax
			ret 
	fib endp


	main proc				
		
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		;-------user code--------
		inint ax

		call fib
		outword bx

		;------------------------
		finish					;завершение работы приложения

	main endp
code ends

end main		;точка входа в программу
