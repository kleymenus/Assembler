include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

date struc
	day db ?
	month db ?
	year dw ?
date ends

data segment
	;---Constants---
	s1 db "Insert day: $"
	s2 db "Insert month: $"
	s3 db "Insert year: $"
	s4 db "Next date: $"
	;---Variables---
	d1 date <>
	d2 date <>
	days db 31,28,31,30,31,30,31,31,30,31,30,31
ends data

code segment
	assume ds:data, cs:code, ss:stk

	isLeap proc
		;функция проверки года
		;push <год>
		;call isLeap
		;pop <result>

		;BP|AB|<год>|...

		push bp
		mov bp, sp

		push ax
		push bx
		push cx
		push dx

		mov bx, [bp+4]

		sub dx,dx			
		mov ax, bx
		mov cx, 400			
		div cx			
		cmp dx, 0
		je _leap				

		sub dx,dx				
		mov ax, bx
		mov cx, 100
		div cx
		cmp dx, 0
		je _nleap

		sub dx,dx
		mov ax, bx
		mov cx, 4
		div cx
		cmp dx, 0
		je _leap

		jmp _nleap

	_leap:
		mov [bp+4], 0001h
		jmp _break	
	_nleap:
		mov [bp+4], 0000h
		jmp _break
	_break:
		pop dx
		pop cx
		pop bx
		pop ax
		pop bp


		ret
	isLeap endp

	main proc				
		
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		;-------user code--------
		sub ax, ax

		lea dx, s1
		outstr
		inint ax
		mov d1.day, al

		lea dx, s2
		outstr
		inint ax
		mov d1.month, al

		lea dx, s3
		outstr
		inint d1.year

		push d1.year	;проверяем на високосность
		call isLeap
		pop dx

		cmp dx, 0
		je _dont_add_feb
			add days+1, 1
		_dont_add_feb:

		mov ax, d1.year	;копируем из d1 в d2
		mov d2.year, ax
		mov al, d1.month
		mov d2.month, al
		mov al, d1.day
		mov d2.day, al

		sub ax, ax
		mov al, d1.month
		mov di, ax
		dec di

		mov al, days[di] ;максимальное кол-во дней в данном месяце
	
		cmp d1.day, al
		jne _dont_reset_day
			mov d2.day, 0	

			cmp d1.month, 12
			jne _dont_reset_month
				mov d2.month, 0
				inc d2.year
			_dont_reset_month:
				inc d2.month
		_dont_reset_day:
			inc d2.day

		sub ax, ax
		newline
		mov al, d2.day
		outint ax
		outch '.'
		mov al, d2.month
		outint ax
		outch '.'
		outint d2.year
		newline


		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
