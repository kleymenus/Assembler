include fslib\fs.asm
include numlib\num.asm
include string.asm

stk segment stack 
	db 100h dup(?)
stk ends

data segment
	;---Constants---
	str1 db "Insert n: $"
	str2 db "Insert numbers: $"
	;---Variables---
	filename db "f.dat",0
	f dw ?
	buf db 100 dup(?)
	n dw ?
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
		;ввод буфера
		strOut str1
		wordIn n
		newline

		strOut str2
		newline

		mov cx, n
		sub di, di
		loop1:
			byteIn buf[di]
			inc di
			newline
		loop loop1

		;создание и запись в файл чисел
		createFile filename, f
		writeFile f, buf, n
		closeFile f

		newline
		;------------------------
		mov ax, 4c00h
		int 21h

	main endp
code ends

end main		;точка входа в программу
