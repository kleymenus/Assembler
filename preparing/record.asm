include io.asm

date record y:7=21, m:4=2, d:5=2

stk segment stack 
	db 100h dup(?)
stk ends

data segment
	;---Constants---
	;---Variables---
	d1 date <12,10,22>
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
			

		;------------------------
		finish					;завершение работы приложения

	main endp
code ends

end main		;точка входа в программу
