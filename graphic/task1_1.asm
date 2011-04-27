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
		
		mov cx, 320
		sub di, di	;по x
		sub si, si	;по y
		loop1:
			line midx, midy, di, 0, 255
			inc di
		loop loop1

		mov cx, 200
		loop2:
			line midx, midy, di, si, 255
			inc si
		loop loop2
		mov cx, 321
		loop3:
			line midx, midy, di, si, 255
			dec di
		loop loop3
		mov cx, 201
		loop4:
			line midx, midy, di, si, 255
			dec si
		loop loop4

		;домик
		line midx-homew, midy-homeh, midx+homew, midy-homeh, 30	;стены
		line midx+homew, midy-homeh, midx+homew, midy+homeh, 30	
		line midx-homew, midy+homeh, midx+homew, midy+homeh, 30
		line midx-homew, midy-homeh, midx-homew, midy+homeh, 30

		line midx-homew, midy-homeh, midx, midy-homeh-10, 30	;крыша
		line midx+homew, midy-homeh, midx, midy-homeh-10, 30

		wordIn ax

		exitGraph	
		;------------------------
		mov ax, 4c00h
		int 21h

	main endp
code ends

end main		;точка входа в программу
