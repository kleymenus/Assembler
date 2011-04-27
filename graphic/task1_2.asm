include numlib\num.asm
include string.asm
include graph\graph.asm

midx equ 320/2
midy equ 200/2

homew equ 20
homeh equ 20

stk segment stack 
	db 100h dup(?)
stk ends

data segment
	;---Constants---
	;---Variables---
data ends

code segment
	assume ds:data, cs:code, ss:stk, es:data

	main proc				
		
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		;-------user code--------
		initGraph
		
		fillScr 30
		
		circle 40, 30, 30, 0

		wordIn ax

		exitGraph	
		;------------------------
		mov ax, 4c00h
		int 21h

	main endp
code ends

end main		;точка входа в программу
