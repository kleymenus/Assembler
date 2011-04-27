include io.asm

stk segment stack
	db 100h dup(?)
stk ends

data segment
	str1 db "Insert N: $"
	str2 db "Insert matrix: $"
	;----
	a dw 100 dup(?)
	n dw ?
data ends

code segment
	assume cs:code, ds:data, ss:stk

	main proc
		push ds
		sub ax, ax
		push ax
		mov ax, data
		mov ds, ax
		;----------
		lea dx, str1
		outstr
		inint n
		
		lea dx, str2
		outstr
		newline

		mov ax, n
		mul n

		mov cx, ax
		sub di, di
		loop1:
			inint a[di]	
			add di, 2
		loop loop1

		mov cx, n
		sub bp, bp
		sub si, si
		loop2:
			push cx
			mov cx, n
			sub di, di 
			sub bx, bx
			loop3:
				mov ax, a[bp][di]
				cmp ax, a[si][bx]
				jne _dont_disp
					outint 1
					jmp _brk
				_dont_disp:
					outint 0
				_brk:

				add di, 2
				add bx, n
				add bx, n
			loop loop3
			pop cx

			newline
			add bp, n
			add bp, n
			add si, 2
		loop loop2

		
		newline
		;---------
		mov ax, 4c00h
		int 21h
	main endp
code ends

end main
