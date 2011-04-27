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
	;---Variables---
	filename1 db "f.dat",0
	filename2 db "g.dat",0
	f dw ?
	g dw ?
	buf db ?
	buf2 db ?
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

		;создание файла g
		setPos f, %START, 0
		createFile filename2, g
		
		loop2:
			readFile f, buf, size, ax	;читаем число из f
			cmp ax, size
			jl _exit2

			setPos g, %START, 0
			loop3:				;проверяем его вхождение в g
				readFile g, buf2, size, bx
				mov cl, buf2
				cmp buf, cl	
				je loop2		;если число встретилось в g, то берем следующее число из f

				cmp bx, size
				jl _exit3
			jmp loop3
			_exit3:
			writeFile g, buf, size		;если число не встретилось, записываем
		jmp loop2
		_exit2:

		closeFile g
		closeFile f

		;вывод g
		strOut str2
		newline
		openFile filename2, g
		loop4:
			readFile g, buf, size, ax
			cmp ax, size
			jl _exit4
			
			unsignByteOut buf
			newline
		jmp loop4
		_exit4:
		closeFile g	

		newline
		;------------------------
		mov ax, 4c00h
		int 21h

	main endp
code ends

end main		;точка входа в программу
