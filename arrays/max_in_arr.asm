include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert N: $"
	s2 db "Insert array: $"
	s3 db "Insert X and Y: $"
	s4 db "Max element belong [x,y]: $"
	s5 db "Not exist such elements$"
	;---Variables---
	n dw ?
	a dw 10 dup(?)
	
ends data

code segment
	assume ds:data, cs:code, ss:stk

	belong proc
		;функция устанавливает dh в 1 если dl принадлежит промежутку [bl;bh]
		;иначе 0
		cmp dl, bl
		jl _ret_nul
		cmp dl, bh
		jg _ret_nul
			mov dh, 1
			jmp _brk
		_ret_nul:
			mov dh, 0
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
		inint n

		mov dx, offset s3
		outstr
		newline
		inint ax
		mov bl, al
		inint ax
		mov bh, al

		mov dx, offset s2
		outstr
		newline

		mov cx, n
		mov di, 0
		loop1:
			inint a[di]
			add di, 2
		loop loop1

		sub ax, ax
		mov cx, n
		mov di, 0
		loop2:
			mov dx, a[di]
			call belong
			cmp dh, 0
			je _dont_mov
				mov ax, a[di]
				jmp loop3
			_dont_mov:

			add di, 2
		loop loop2
			mov dx, offset s5
			outstr
			jmp _exit
		loop3:
			cmp ax, a[di]
			jge _dont_mov2

			mov dx, a[di] 
			call belong
			cmp dh, 0
			je _dont_mov2
				mov ax, a[di]
			_dont_mov2:
			
			add di, 2
		loop loop3

		mov dx, offset s3
		outstr
		outint ax

		newline

		_exit:
		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
