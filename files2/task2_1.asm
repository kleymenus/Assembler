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
		strout str1
		newline

		openfile filename1, f
	
		loop1:
			readfile f, buf, size, ax

			signbyteout buf
			charOut ' '

			cmp ax, size
			jl _exit1
		jmp loop1
		_exit1:
		newline

		;четние файла f, по 5, и сохранение неотр. чисел в стеке и запись отр. в g
		setPos 	f, %START, 0
		createFile filename2, g
		loop2:
			mov cx, 5
			sub bx, bx
			loop3:
				readfile f, buf, size, ax
				cmp ax, size
				jl _exit2

				cmp buf, 0
				jl _neg
					;неотрицательные
					mov dl, buf
					sub dh, dh
					push dx

					inc bx		;счетчик 
					jmp _brk1
				_neg:
					;записываем отрицательные
					writeFile g, buf, size, ax
				_brk1:
			loop loop3
			
			mov cx, bx
			loop4:
				pop dx		;достаем отр. из стека и записываем
				mov buf, dl
				writeFile g, buf, size, ax
			loop loop4
		jmp loop2
		_exit2:

		closeFile f
		closeFile g

		;вывод g.dat
		strout str2
		newline
		openfile filename2, g
	
		loop5:
			readfile g, buf, size, ax
			signbyteout buf
			charOut ' '

			cmp ax, size
			jl _exit5
		jmp loop5
		_exit5:
		closeFile g

		newline
		;------------------------
		mov ax, 4c00h
		int 21h

	main endp
code ends

end main		;точка входа в программу
