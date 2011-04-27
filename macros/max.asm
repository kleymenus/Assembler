include io.asm

;помещение в ax максимального эл-та словного массива x состоящего из n эл-тов
max macro x,n 
	local loop1, _dont_mov

	push cx
	push di

	mov ax, a[0]	;максимальный

	mov cx, n
	sub di, di
	loop1:
		cmp ax, a[di]	
		jge _dont_mov
			mov ax, a[di]
		_dont_mov:

		add di, 2
	loop loop1

	pop di
	pop cx
endm

stk segment stack 
	db 100h dup(?)
stk ends

data segment
	;---Constants---
	str1 db "Insert N: $"
	str2 db "Insert array: $"
	str3 db "Max: $"
	;---Variables---
	a dw 100 dup(?)
	n dw ?
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
		inint n

		lea dx, str2
		outstr

		mov cx, n
		sub di, di
		loop1:
			inint a[di]			
			add di, 2
		loop loop1

		max a, n	
		lea dx, str3
		outstr
		outint ax
		
		newline

		;------------------------
		finish					;завершение работы приложения

	main endp
code ends

end main		;точка входа в программу
