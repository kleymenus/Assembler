include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	;---Variables---
	str1 db "      6lololo   3bsss 1   4 1     5 1$"
	n dw 31
ends data

code segment
	assume ds:data, cs:code, ss:stk, es:data

	main proc				
		
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		mov es, ax
		;-------user code--------
		lea dx, str1
		outstr
		newline
		

		mov al, ' '

		lea di, str1
		sub dx, dx
		loop1:
			repne scasb
			mov bx, di
			repe scasb
			sub bx, di
			neg bx

			cmp dx, bx
			jge _dont_mov
				mov dx, bx
			_dont_mov:
			cmp di, n 
		jl loop1

		newline
		outint dx
		newline

		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
