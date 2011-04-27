include io.asm

reserv macro name
	n=1
	name db n
	rept 39 
		n = n+2
		db n
	endm
endm

stk segment stack 
	db 100h dup(?)
stk ends

data segment
	;---Constants---
	;---Variables---
	reserv a
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
		mov cx, 40
		sub di, di
		sub ax, ax
		loop1:
			mov al, a[di]
			outint ax
			inc di
			newline
		loop loop1
			
		newline
		;------------------------
		finish					;завершение работы приложения

	main endp
code ends

end main		;точка входа в программу
