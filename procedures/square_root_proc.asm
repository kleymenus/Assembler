include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert count of numbers: $"
	s2 db "Insert sequance$"
	s3 db "Count of full square: $"
	;---Variables---
ends data

code segment
	assume ds:data, cs:code, ss:stk
	
	root proc
		;функция возращает в dx 1, если ax является полным квадратом
		;иначе функция возращает 0

		;сохраняем первоначальные значения регистров
		push ax
		push bx	

		mov bx, 1
		cycle1:
			sub ax, bx	;будем последовательно вычитать из числа последовательность нечетных чисел
			add bx, 2

			cmp ax,0
			je _full_square	;если ax = 0, то квадрат - полный
		jg cycle1
			mov dx, 0		;ax - не полный квадрат
			jmp _brk
		_full_square:
			mov dx, 1		;ax - полный квадрат
		_brk:

		;восстановление значений регистров
		pop bx
		pop ax
		
		ret
	root endp

	main proc				
		
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		;-------user code--------
		mov dx, offset s1
		outstr
		inint cx

		mov dx, offset s2
		outstr
		newline

		sub dx,dx
		sub bx,bx
		loop1:
			inint ax
			call root
			cmp dx, 0
			je _dont_inc
				inc bx
			_dont_inc:
		loop loop1

		newline
		mov dx, offset s3
		outstr
		outint bx
		newline


		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
