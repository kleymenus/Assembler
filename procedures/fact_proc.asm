include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "The programm calculate binomial coefficient$"
	s2 db "Insert n: $"
	s3 db "Insert m: $"
	;---Variables---
	m dw ?
	n dw ?
ends data

code segment
	assume ds:data, cs:code, ss:stk		;сопоставление сегментам указанных регистров

	fact proc
		;ax - входной  параметр
		;dx - выходной параметр
	
		mov cx, ax
		mov ax, 1

		cycle1:
			mul cx	
		loop cycle1
		mov dx, ax

		ret
	fact endp

	main proc				
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		;-------user code--------

		mov dx, offset s1
		outstr
		newline
		
		mov dx, offset s2
		outstr
		inint n

		mov dx, offset s3
		outstr
		inint m

	
		mov ax, n		;сохранение в стеке n!
		call fact
		push dx	

		mov ax, m		;сохранение в стеке m!
		call fact
		push dx

		mov ax, n		;вычисление (n-m)!
		sub ax, m
		call fact
		
		
		pop ax			;взять из стека m!
		mul dx			;и умножить на (n-m)!

		sub dx, dx
		mov bx, ax		;результат в bx
		pop ax			;в ax поместить n!
		div bx			;n! разделить на m!(n-m)!

		newline
		outint ax
		newline

		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
