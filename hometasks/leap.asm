include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert year: $"
	lp db "Is leap$"
	nlp db "Is not leap$"
	;---Variables---
ends data

code segment
	main proc				
		assume ds:data, cs:code, ss:stk		;сопоставление сегментам указанных регистров
		
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		;-------user code--------
		mov dx, offset s1			;
		outstr					;вводим год
		inint bx				;
			
		sub dx,dx				;dx=0
		mov ax, bx
		mov cx, 400				;
		div cx					;dx = bx mod 400
		cmp dx, 0
		je _leap				

		sub dx,dx				;dx=0
		mov ax, bx
		mov cx, 100
		div cx
		cmp dx, 0
		je _nleap

		sub dx,dx				;dx=0
		mov ax, bx
		mov cx, 4
		div cx
		cmp dx, 0
		je _leap

		jmp _nleap

	_leap:
		mov dx, offset lp
		outstr
		jmp _break	
	_nleap:
		mov dx, offset nlp
		outstr
		jmp _break
	_break:
		
		newline
		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
