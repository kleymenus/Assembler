include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert N: $"
	s2 db "Insert sequence: $"
	s3 db "Sequence is increasing.$"
	s4 db "Sequence is not increasing.$"
	;---Variables---
ends data

code segment
	assume ds:data, cs:code, ss:stk

	is_increase proc
		mov dx, offset s1
		outstr 
		inint cx
		sub cx, 2

		mov dx, offset s2
		outstr
		newline

		mov ax, 0001h

		inint bx
		inint dx
		_loop_is_increase:
			cmp bx, dx
			jle _dont_change_fl
				mov ax, 0000h
			_dont_change_fl:

			push dx
			inint dx
			pop bx
		loop _loop_is_increase

		cmp ax, 0
		je _print_no
			mov dx, offset s3
			outstr
			jmp exit_is_increase
		_print_no:
			mov dx, offset s4
			outstr
		exit_is_increase:

		newline

		ret
	is_increase endp

	main proc				
		
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		;-------user code--------
		call is_increase

		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
