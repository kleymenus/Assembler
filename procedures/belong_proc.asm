include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert x: $"
	s2 db "Insert y: $"
	s3 db "Insert count of numbers, which should be checked: $"
	s4 db "This number belong to [x;y]$"
	;---Variables---
ends data

code segment
	assume ds:data, cs:code, ss:stk
	
	belong proc
		;функция устанавливает ah в 1 если al принадлежит промежутку [bl;bh]
		;иначе 0
		cmp al, bl
		jl _ret_nul
		cmp al, bh
		jg _ret_nul
			mov ah, 1
			jmp _brk
		_ret_nul:
			mov ah, 0
		_brk:

		ret
	belong endp

	main proc				
		
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		;-------user code--------
		mov dx, offset s1
		outstr
		inint ax
		mov bl, al

		mov dx, offset s2
		outstr
		inint ax
		mov bh, al

		mov dx, offset s3
		outstr
		inint cx

		sub ax,ax
		loop1:
			inint ax
			call belong
			cmp ah, 0
			je _dont_alert
				mov dx, offset s4
				outstr
				newline
			_dont_alert:

		loop loop1

		newline

		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
