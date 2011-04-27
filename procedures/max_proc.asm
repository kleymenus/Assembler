include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert numbers: $"
	s2 db "Insert count numbers: $"
	;---Variables---
	b dw ?
	max dw ?
ends data

code segment
	assume ds:data, cs:code, ss:stk		;сопоставление сегментам указанных регистров
	
	max_proc proc
		;передача параметров будет идти через ax и bx	
		;максимум будет в dx
		sub dx, dx

		cmp ax, bx
		jg _ax_gr_bx
		mov dx, bx
		jmp _break
	_ax_gr_bx:
		mov dx, ax	;возвратить ax
	_break:

		ret
	max_proc endp
	
	main proc				
		
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		;-------user code--------
		mov dx, offset s2
		outstr
		inint cx
		dec cx

		mov dx, offset s1
		outstr
		newline

		inint max
	cycle1:
		inint b

		mov ax, max
		mov bx, b
		call max_proc
		mov max, dx
	loop cycle1
		
		newline
		outint max
		newline


		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
