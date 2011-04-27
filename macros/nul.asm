include io.asm

;x- словный массив, n - кол-во эл-тов, t = (first || last)
nul macro x,n,t
	local loop1

	push di

	ifidn t, first
		sub di, di
	else 
		mov di, n*2-2
		add di, n
		sub di, 2
	endif

	mov cx, n	
	loop1:
		mov x[di], 0

		ifidn t, first
			add di, 2
		else
			sub di, 2
		endif
	loop loop1

	pop di
endm

stk segment stack 
	db 100h dup(?)
stk ends

data segment
	;---Constants---
	;---Variables---
	a dw 1,4,5,1,9,15
	n dw 6
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
		nul a, n, first

		mov cx, n
		sub di, di
		loop1:
			outint a[di]
			outch ' '

			add di, 2
		loop loop1

		newline

		;------------------------
		finish					;завершение работы приложения

	main endp
code ends

end main		;точка входа в программу
