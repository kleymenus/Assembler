include fslib\fs.asm
include numlib\num.asm
include string.asm

size = 1

stk segment stack 
	db 100h dup(?)
stk ends

data segment
	;---Constants---
	str1 db "CH.DAT: $"
	;---Variables---
	filename1 db "ch.dat",0
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
		;чтение и вывод f
		strOut str1
		newline
		openFile filename1, f
	
		loop1:
			readFile f, buf, size, ax
			charOut buf

			cmp ax, size
			jl _exit1
		jmp loop1
		_exit1:
		newline

		;подсчет кол-ва вхождений 'ab' без пересечений
		setPos f, %START, 0

		sub bx, bx		;кол-во
		loop2:
			readFile f, buf, size, ax
			cmp buf, 'a'
			jne _skip

			readFile f, buf, size, ax
			cmp buf, 'b'
			jne _skip
				inc bx
			_skip:

			cmp ax, size
			jl _exit2
		jmp loop2
		_exit2:
		newline

		unsignWordOut bx
		newline
		;------------------------
		mov ax, 4c00h
		int 21h

	main endp
code ends

end main		;точка входа в программу
