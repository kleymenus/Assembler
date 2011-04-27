include io.asm

subm macro a, b
	mov ax, a
	sub ax, b	;ax = a-b
endm

stk segment stack 
	db 100h dup(?)
stk ends

data segment
	;---Constants---
	;---Variables---
	x dw ?
	y dw ?
data ends

code segment
	assume ds:data, cs:code, ss:stk

	main proc				
		
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		;-------user code--------
		inint ax
		inint y
		newline

		subm ax, y
		outint ax

		;------------------------
		finish					;завершение работы приложения

	main endp
code ends

end main		;точка входа в программу
