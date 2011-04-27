include io.asm

stk segment stack 
	db 100h dup(?)
stk ends

data segment
	;---Constants---
	;---Variables---
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
		;if (ax>0) then s1 else s2

		mov ax, -1


		cmp ax, 0
		jle _temp
		_temp: jmp _dont_s1
			outint 1
			jmp _brk
		_dont_s1:
			outint 2
		_brk:

		;------------------------
		finish					;завершение работы приложения

	main endp
code ends

end main		;точка входа в программу
