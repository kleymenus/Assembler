include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert x: $"
	s2 db "Insert y: $"
	;---Variables---
	x dw ?
	y dw ?
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
		outstr					;ввод x
		inint x					;

		mov dx, offset s2			;
		outstr					;ввод y
		inint y					;

		sub bx,bx

		cmp x,0
		jg one_or_four
		cmp y,0 				;если x<0	
		jg two
		mov bx, 3				;если x<0 и y<0
		outint bx
		jmp _break
	
	one_or_four:					;если x>0
		cmp y,0
		jg one
		mov bx, 4				;если x>0 и y<0
		outint bx
		jmp _break
	one:						;если x>0 и y>0
		mov bx, 1
		outint bx
		jmp _break
	two:						;если x<0, y>0
		mov bx, 2
		outint bx
		jmp _break
	_break:
		newline
		
		

			
		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
