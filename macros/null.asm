include io.asm

outdd macro 
	irp n, <a,b,c>
		lea di, n
		mov ax,  word ptr [di]
		outint ax
		mov ax,  word ptr [di+2]
		outint ax
		newline
	endm
endm

stk segment stack 
	db 100h dup(?)
stk ends

data segment
	;---Constants---
	;---Variables---
	a dd 0FFFFh
	b dd 0AAAAh
	c dd 04939h
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
		outdd
		irp n, <a,b,c>
			lea di, n
			mov word ptr [di], 0
			mov word ptr [di+2], 0
		endm
		
		newline
	
		outdd
		;------------------------
		finish					;завершение работы приложения

	main endp
code ends

end main		;точка входа в программу
