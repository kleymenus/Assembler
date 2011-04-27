include fslib\fs.asm
include numlib\num.asm
include string.asm

stk segment stack 
	db 100h dup(?)
stk ends

data segment
	;---Constants---
	str1 db "end$"
	;---Variables---
	filename db "txt",0
	f dw ?
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
		openFile filename, f
		setPos f, %END, 0
		writeFile f, str1, 3, ax
		

		closeFile f
		;------------------------
		mov ax, 4c00h
		int 21h

	main endp
code ends

end main		;точка входа в программу
