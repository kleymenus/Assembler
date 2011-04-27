include io.asm

cout macro str1
	irpc p, str1
		outch '&p&'
	endm
endm

max macro a, b, c
	local _max_a, _brk

	push ax

	mov ax, a
	cmp ax, b
	jg _max_a
		mov ax, b
		mov c, ax
		jmp _brk
	_max_a:
		mov ax, a
		mov c, ax
	_brk:

	pop ax
endm

max3 macro a, b, c, d
	max a, b, d
	max d, c, d
endm


stk segment stack 
	db 100h dup(?)
stk ends

data segment
	;---Constants---
	;---Variables---
	x dw ?
	y dw ?
	z dw ?
	t dw ?
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
		cout Insert_numbers:
		newline
		
		inint x
		inint y
		inint z


		max3 x,y,z,t

		cout Max:
		outint t

		newline

		;------------------------
		finish					;завершение работы приложения

	main endp
code ends

end main		;точка входа в программу
