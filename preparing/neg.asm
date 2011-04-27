include io.asm

stk segment stack 
	db 100h dup(?)
stk ends

data segment
	;---Constants---
	;---Variables---
	str1 db "CF=1$"
	str2 db "CF=0$"
	str3 db "OF=1$"
	str4 db "OF=0$"
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
		mov al, 0
		neg al
		
		jc _set_cf
			lea dx, str2
			outstr
			jmp _brk1
		_set_cf:
			lea dx, str1
			outstr
		_brk1:

		newline
		
		jo _set_of
			lea dx, str4
			outstr
			jmp _brk2
		_set_of:
			lea dx, str3
			outstr
		_brk2:

		newline

		;------------------------
		finish					;завершение работы приложения

	main endp
code ends

end main		;точка входа в программу
