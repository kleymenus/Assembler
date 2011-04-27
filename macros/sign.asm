include io.asm

sign macro x
	local _neg, _zer, _brk

	cmp x, 0
	jl _neg
	je _zer
		mov ax, 1
		jmp _brk
	_neg:
		mov ax, -1
		jmp _brk
	_zer:
		mov ax, 0
	_brk:
endm

stk segment stack 
	db 100h dup(?)
stk ends

data segment
	;---Constants---
	str1 db "Insert x: $"
	str2 db "sign(x) = $"
	;---Variables---
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
		inint ax

		sign ax

		lea dx, str2
		outstr
		outint ax

		newline
		;------------------------
		finish					;завершение работы приложения

	main endp
code ends

end main		;точка входа в программу
