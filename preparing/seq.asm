include io.asm

stk segment stack
	db 100h dup(?)
stk ends

data segment
	n dw ?
data ends

code segment
	assume cs:code, ds:data, ss:stk

	temp proc
		cmp ax, bx
		jle _dont_change
			mov dx, 0
		_dont_change:

		ret
	temp endp

	main proc
		push ds
		sub ax, ax
		push ax
		mov ax, data
		mov ds, ax
		;-----------
		inint n	

		mov dx, 1

		mov cx, n
		sub cx, 2

		inint ax
		inint bx
		call temp
		jcxz _skip
		loop1:
			mov ax, bx
			inint bx
			
			call temp
		loop loop1
		_skip:

		outint dx

		;-----------
		mov ax, 4c00h
		int 21h
	main endp
code ends

end main
