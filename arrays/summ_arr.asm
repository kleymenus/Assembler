include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert N: $"
	s2 db "Insert elements: $"
	s3 db "Summ of positive el-ts: $"
	;---Variables---
	a dw 10 dup(?)
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
		inint n

		mov dx, offset s2
		outstr
		newline

		mov cx, n
		mov bx, 0
		loop1:
			inint a[bx]
			add bx, 2 
		loop loop1

		mov cx, n
		mov bx, 0
		sub ax,ax
		loop2:
			cmp a[bx], 0
			jle _dont_add
				add ax, a[bx]
			_dont_add:
			add bx, 2
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
