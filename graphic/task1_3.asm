include numlib\num.asm
include string.asm
include graph\graph.asm

midx equ 320/2
midy equ 200/2

sin5 equ 22
cos5 equ 255

rad equ 100

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

		;будем поворачивать точку на 10 градусов
		;(2^8)*sin(10 deg) = 44
		;(2^8)*cos(10 deg) = 252
		;(si, di) - текущие координаты 
		;(bx, bp) - новые координаты

		mov si, midx
		mov di, midy + rad
		loop1:
			fillscr 30
			line midx,midy, si, di, 0	

			push cx
			mov cx, 32000
			loop2:
				nop
			loop loop2
			pop cx

			;перейдем в начало координат
			sub si, midx
			sub di, midy

			;повернем:
			;(2^8)x' = (2^8)x*cos5+ (2^8)y*sin5
			mov ax, cos5	;(2^8)*x*cos5
			imul si
			mov bx, ax

			mov ax, sin5	;(2^8)*y*sin5
			imul di
			add bx, ax
			sar bx, 8	;bx = x'


			;(2^8)y' = -(2^8)x*sin5 + (2^8)y*cos5
			mov ax, sin5
			imul si
			mov bp, ax
			neg bp

			mov ax, cos5
			imul di
			add bp, ax

			sar bp, 8	;si = x'

			;x = x'; y = y'
			mov si, bx
			mov di, bp

			;вернемся из начала координат
			add si, midx
			add di, midy
		jmp loop1
		

		wordIn ax

		exitGraph	
		;------------------------
		mov ax, 4c00h
		int 21h

	main endp
code ends

end main		;точка входа в программу
