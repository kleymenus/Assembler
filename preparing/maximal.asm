include io.asm

stk segment stack 
	db 100h dup(?)
stk ends

data segment
	;---Constants---
	;---Variables---
	m1 db ?
	m2 db ?
	m db ?
data ends

code segment
	assume ds:data, cs:code, ss:stk

	showBits proc
		;в al будет байт
		push ax

		mov cx, 8
		_showBits_loop:
			test al, 00000001b
			jz _zero
				push 1
				jmp _showBits_brk
			_zero:
				push 0
			_showBits_brk:

			shr al, 1
		loop _showBits_loop

		mov cx, 8
		_showBits_loop2:
			pop ax
			outint ax
		loop _showBits_loop2

		pop ax
		ret
	showBits endp

	main proc				
		
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		;-------user code--------
		mov m1, 11111111b
		mov al, m1
		call showBits
		newline

		mov m2, 11100111b
		mov al, m2
		call showBits
		newline

		mov al, m1
		xor al, m2
		and al, m1
		call showBits
		newline

		;------------------------
		finish					;завершение работы приложения

	main endp
code ends

end main		;точка входа в программу
