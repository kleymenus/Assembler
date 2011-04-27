include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert N: $"
	s2 db "Insert sequence: $"
	;---Variables---
	n dw ?
	numb dw ?
ends data

code segment
	assume ds:data, cs:code, ss:stk

	cnt_numb proc
		;функция возращает кол-во цифр в числе
		;использование:
		;push <numb>
		;call cnt_numb
		;pop <result>

		push bp	
		mov bp, sp

		push ax
		push bx
		push cx
		push dx
		mov ax, [bp+4]

		sub cx, cx
		mov bx, 10
		_loop_cnt_nump:
			sub dx,	dx
			div bx
			inc cx
			
			cmp ax, 0
		jne _loop_cnt_nump
		
		mov [bp+4], cx 

		pop dx
		pop cx
		pop bx
		pop ax
		pop bp

		ret
	cnt_numb endp

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

		sub dx, dx		;в numb последняя цифра первого эл-та
		inint ax
		push ax
		mov bx, 10
		div bx
		mov numb, dx

		sub ax, ax		;в ax - произведение
		mov ax, 1

		pop bx			;bx - текущий э-т
		push bx
		call cnt_numb		;проверка первого эл-та
		pop dx			;dx - кол-во цифр
		cmp dx, numb 
		jge _dont_mul
			imul bx
		_dont_mul:


		mov cx, n
		dec cx
		loop1:
			inint bx

			push bx
			call cnt_numb
			pop dx

			cmp dx, numb
			jge _dont_mul1
				imul bx
			_dont_mul1:
			
		loop loop1

		newline
		outint ax
		newline

		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
