include fslib\fs.asm
include numlib\num.asm
include string.asm

size = 1

stk segment stack 
	db 100h dup(?)
stk ends

data segment
	;---Constants---
	str1 db "F.DAT: $"
	str2 db "G.DAT: $"
	str3 db "H.DAT: $"
	;---Variables---
	filename1 db "f.dat",0
	filename2 db "g.dat",0
	filename3 db "h.dat",0
	f dw ?
	g dw ?
	h dw ?
	buf db ?
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
		;чтение и вывод f
		strOut str1
		newline

		openFile filename1, f
	
		loop1:
			readFile f, buf, size, ax

			unsignByteOut buf
			newline

			cmp ax, size
			jl _exit1
		jmp loop1
		_exit1:

		;запись в g - четных чисел, в h - нечетных
		setPos f, %START, 0
		createFile filename2, g
		createFile filename3, h

		loop2:
			readFile f, buf, size, ax
			test buf, 00000001b
			jz _parity
				;нечетный
				writeFile h, buf, size
				jmp _brk
			_parity:
				;четный
				writeFile g, buf, size
			_brk:

			cmp ax, size
			jl _exit2
		jmp loop2
		_exit2:

		closeFile f
		closeFile g
		closeFile h

		newline
		;вывод g
		strOut str2
		newline
		openFile filename2, g
		loop3:
			readFile g, buf, size, ax
			unsignByteOut buf
			newline

			cmp ax, size
			jl _exit3
		jmp loop3
		_exit3:
		closeFile g	

		newline
		;вывод h
		strOut str3
		newline
		openFile filename3, h
		loop4:
			readFile h, buf, size, ax
			unsignByteOut buf
			newline

			cmp ax, size
			jl _exit4
		jmp loop4
		_exit4:
		closeFile h


		
		newline
		;------------------------
		mov ax, 4c00h
		int 21h

	main endp
code ends

end main		;точка входа в программу
