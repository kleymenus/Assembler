include io.asm

stk segment stack
	db 100h dup(?)
stk ends

data segment
	
data ends

code segment
 	assume cs:code, ds:data, ss:stk
 	
	isPrime proc
		;использование
		;push <numb>
		;call isPrime
		;pop <result>
		;BP|AB|numb|...

		push bp
		mov bp, sp

		push ax
		push bx
		push cx
		push dx

		mov cx, [bp+4]
		sub cx, 2

		cmp cx, 0
		jl _not_prime

		jcxz _prime

		mov bx, [bp+4]
		dec bx

		_isPrime_loop:
			sub dx, dx
			mov ax, [bp+4]
			div bx

			cmp dx, 0
			je _not_prime

			dec bx
		loop _isPrime_loop
		_prime:
			mov [bp+4], 0001h
			jmp _prime_break
		_not_prime:
			mov [bp+4], 0000h
		_prime_break:

		pop dx
		pop cx
		pop bx
		pop ax
		pop bp

		ret
	isPrime endp

	main proc
		push dx
		sub ax, ax
		push ax
		mov ax, data
		mov ds, ax
		;---user code-----
		inint cx

		loop1:
			inint ax
			push ax
			call isPrime
			pop dx
			outint dx
			newline
		loop loop1

		;-----------------	
		mov ax, 4c00h
		int 21h
	main endp
code ends

end main
