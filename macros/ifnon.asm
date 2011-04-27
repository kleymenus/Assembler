include io.asm

ifnull macro x, l
	cmp x, 0
	je l
endm

stk segment stack 
	db 100h dup(?)
stk ends

data segment
	;---Constants---
	str1 db "Insert x: $"
	str2 db "Null$"
	str3 db "Not null$"
	;---Variables---
	x dw ?
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
		lea dx, str1
		outstr
		
		inint x

		ifnull x, _null
			lea dx, str3
			outstr
			jmp _brk
		_null:
			lea dx, str2
			outstr
		_brk:

		newline

		;------------------------
		finish					;завершение работы приложения

	main endp
code ends

end main		;точка входа в программу
