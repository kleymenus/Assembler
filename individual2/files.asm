include fslib\fs.asm
include numlib\num.asm
include string.asm

size = 1

stk segment stack 
	db 100h dup(?)
stk ends

data segment
	;---Constants---
	str1 db "Insert X: $"
	str2 db "Insert n: $"
	str3 db "Insert array: $"
	str4 db "Max element of array: $"
	str5 db "F.DAT: $"
	;---Variables---
	x db ?
	a db 100 dup(?)
	n db ?
	filename db "f.dat",0
	f dw ?
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
		;ввод x
		strOut str1
		byteIn x
		newline
		newline


		;ввод массива
		strOut str2
		byteIn n
		newline

		strOut str3
		newline
		mov cl, n
		sub ch, ch
		sub di, di
		loop1:
			byteIn a[di]	
			newline

			inc di
		loop loop1


		;поиск максимального в массиве
		mov bl, a[0]				;bl - максимальный
		mov cl, n
		sub di, di
		loop2:
			cmp bl, a[di]
			jge _skip2
				mov bl, a[di]
			_skip2:

			inc di
		loop loop2
		strOut str4
		unsignByteOut bl
		newline


		;чтение и вывод f
		strOut str5
		newline
		openFile filename, f
	
		loop3:
			readFile f, buf, size, ax
			cmp ax, size
			jl _exit3

			unsignByteOut buf
			charOut ','
			charOut ' '
		jmp loop3
		_exit3:
		newline


		;просмотр файла f и замена в нем эл-тов больших x (x=dl)
		setPos f, %START, 0
		mov dl, x

		loop4:
			readFile f, buf, size, ax
			cmp ax, size
			jl _exit4

			cmp buf, dl	
			jle _skip4			;если прочитанный элемент больше x
				setPos f, %CUR, -1	;то вернутся назад на 1 байт
							;и записать bl
				mov buf, bl
				writeFile f, buf, size
			_skip4:
		jmp loop4
		_exit4:

	
		;вывод файла f
		strOut str5
		newline
		setPos f, %START, 0
	
		loop5:
			readFile f, buf, size, ax
			cmp ax, size
			jl _exit5

			unsignByteOut buf
			charOut ','
			charOut ' '
		jmp loop5
		_exit5:
		newline

		closeFile f

		;------------------------
		mov ax, 4c00h
		int 21h

	main endp
code ends

end main		;точка входа в программу
