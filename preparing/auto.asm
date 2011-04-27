include io.asm

info struc
	mark db 16 dup('$')
	numb dw 0
	owner db 16 dup('$')
info ends

stk segment stack
	db 100h dup(?)
stk ends

data segment
	s1 db "Insert N: $"
	s2 db "Mark: $"
	s3 db "Number: $"
	s4 db "Owner: $"
	;-----------------
	a info 10 dup(<>)
	n dw ?
	str1 db "Honda$"
data ends

code segment
	assume cs:code, ds:data, ss:stk, es:data

	readStr proc
		;BP|AB|str|...
		push bp
		
		mov bp, sp

		push ax
		push bx
		push cx
		push dx

		mov ah, 3fh
		mov bx, 0
		mov cx, 15
		mov dx, [bp+4]
		
		int 21h

		pop dx
		pop cx
		pop bx
		pop ax
		pop bp

		ret 2
	readStr endp

	main proc
		push ds
		sub ax, ax
		push ax
		mov ax, data
		mov ds, ax
		mov es, ax
		;-----------------
		lea dx, s1
		outstr
		inint n
		newline

		mov cx, n
		sub di, di
		loop1:
			lea dx, s2
			outstr
			lea dx, a[di].mark
			push dx
			call readStr

			lea dx, s3
			outstr
			inint a[di].numb

			lea dx, s4
			outstr
			lea dx, a[di].owner
			push dx
			call readStr

			newline

			add di, type info
		loop loop1

		mov cx, n
		sub bx, bx
		loop2:
			push cx
			mov cx, 5
			lea di, str1
			lea si, a[bx].mark

			repe cmpsb

			jcxz _equal
				jmp _brk
			_equal:
				lea dx, a[bx].owner
				outstr
			_brk:
			add bx, type info

			pop cx
		loop loop2

		newline

		;-----------------
		mov ax, 4c00h
		int 21h
	main endp
code ends

end main
