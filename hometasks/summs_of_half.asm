include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert n: $"
	s2 db "Summs of half is equal$"
	s3 db "Summs of half is not equal$"
	n dw ?
	summ1 dw 0
	summ2 dw 0
	;---Variables---
ends data

code segment
	main proc				
		assume ds:data, cs:code, ss:stk		;сопоставление сегментам указанных регистров
		
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		;-------user code--------
		sub cx, cx
		sub ax, ax
		
		mov dx, offset s1			;
		outstr					;ввод n
		inint n					;
		
		sub dx, dx
		mov ax, n
		mov bx, 2
		div bx
		mov cx, ax
	_seq1:
		inint bx
		add summ1, bx
	loop _seq1
		mov cx, ax
	_seq2:
		inint bx
		add summ2, bx
	loop _seq2
		newline

		mov dx, summ2
		cmp summ1, dx
		je _is_equal
		mov dx, offset s3
		outstr
		jmp _break

	_is_equal:
		mov dx, offset s2
		outstr
	_break:
		newline


		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
