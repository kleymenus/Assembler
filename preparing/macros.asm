include io.asm



Foo macro name1, name2, n
	byteArr macro name, k
		name db k dup(?)
	endm

	byteArr name1, n
	byteArr name2, n
endm
	

stk segment stack 
	db 100h dup(?)
stk ends

data segment
	;---Constants---
	;---Variables---
	Foo arr1, arr2, 10

	byteArr arr3, 10
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
