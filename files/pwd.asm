include numlib\num.asm
include string.asm

stk segment stack 
	db 100h dup(?)
stk ends

data segment
	;---Constants---
	;---Variables---
	path db 64 dup(0), 0
data ends

code segment
	assume ds:data, cs:code, ss:stk, es:data

	main proc				
		
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		mov es, ax
		;-------user code--------
		;диск
		mov ah, 19h
		int 21h
		add al, 'A'	;преобразование в букву
		charOut al

		charOut ':'
		charOut '\'

		;получение пути
		mov dl, 0
		mov ah, 47h
		lea si, path
		int 21h
		convert path
		strOut path

		newline
		;------------------------
		mov ax, 4c00h
		int 21h

	main endp
code ends

end main		;точка входа в программу
