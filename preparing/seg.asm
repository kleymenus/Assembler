include io.asm

stk segment stack 
	db 100h dup(?)
stk ends

data segment
	f dw 42 
	addr1 dw 3:5 
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
		mov ax, data
		outword ax
		newline
		mov ax, seg data
		outword ax

		;------------------------
		finish					;завершение работы приложения

	main endp
code ends

end main		;точка входа в программу
