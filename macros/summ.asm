include io.asm

summ macro
	mov ah, al
	add ah, bl
	add ah, cl
	add ah, dh
endm

stk segment stack 
	db 100h dup(?)
stk ends

data segment
	;---Constants---
	;---Variables---
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
		mov al, 1
		mov bl, 2
		mov cl, 3
		mov dh, 4
		summ

		mov al, ah
		sub ah, ah
		outint ax

		;------------------------
		finish					;завершение работы приложения

	main endp
code ends

end main		;точка входа в программу
