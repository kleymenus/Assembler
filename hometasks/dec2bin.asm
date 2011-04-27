include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert x: $"
	;---Variables---
	x dw ?
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
		mov dx, offset s1			;ввод x
		outstr					;
		inint x					;	

		mov bx,2
	cicle1:	
		sub dx,dx				;очищяем dx

		mov ax,x				;ax = ax div 2
		div bx 					;dx = ax mod 2

		outint dx				;кладем остаток в стек
		
		cmp al,2				;если ax div 2 == 0
		je exit					;то выходим из цикла
	jmp cicle1					;иначе продолжаем цикл
	exit:
		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
