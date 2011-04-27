include io.asm

def macro x,t,n,v
	x d&t v	
	rept n-1
		d&t v
	endm
endm

stk segment stack 
	db 100h dup(?)
stk ends

data segment
	;---Constants---
	;---Variables---
	def a,w,10,42
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
		mov cx, 10
		sub di, di
		loop1:
			outint a[di]
			add di, 2
			newline
		loop loop1

		;------------------------
		finish					;завершение работы приложения

	main endp
code ends

end main		;точка входа в программу
