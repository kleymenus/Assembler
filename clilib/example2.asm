include clilib\cli.asm
include numlib\num.asm
include string.asm

stk segment stack 
	db 100h dup(?)
stk ends

data segment
	;---Constants---
	;---Variables---
data ends

code segment
	assume ds:data, cs:code, ss:stk, es:data

	;Задержка
	sleep proc
		pusha
		
		mov cx, 40000
		_sleep_loop:
			nop
		loop _sleep_loop

		popa
		ret
	sleep endp

	;Движение символа ch по периметру прямоугольника
	moveRectangle proc
		;usage:
		;push <x:y>
		;push <w:h>
		;push <ch: >
		;call moveRectangle
		;
		;BP|IP|ch: |w:h|x:y|...
		push bp
		mov bp, sp
		pusha

		mov ax, [bp+8]		;al - текущий x, ah - текущий y
		mov dl, [bp+4]		;dl - символ
		
		;движение по верхней стороне
		setCur al, ah

		mov cl, [bp+6]
		sub ch, ch
		_moveRect_loop1:
			getChar bl, bh		;в bl текущий символ
			attrCharOut dl

			call sleep

			attrCharOut bl		;затираем 
			inc al
			setCur al, ah
		loop _moveRect_loop1

		mov cl, [bp+7]
		_moveRect_loop2:
			getChar bl, bh
			attrCharOut dl

			call sleep

			attrCharOut bl
			inc ah
			setCur al, ah
		loop _moveRect_loop2

		mov cl, [bp+6]
		_moveRect_loop3:
			getChar bl, bh
			attrCharOut dl

			call sleep

			attrCharOut bl
			dec al
			setCur al, ah
		loop _moveRect_loop3

		mov cl, [bp+7]
		_moveRect_loop4:
			getChar bl, bh
			attrCharOut dl

			call sleep

			attrCharOut bl
			dec ah
			setCur al, ah
		loop _moveRect_loop4

		popa
		pop bp
		ret 6
	moveRectangle endp

	main proc				
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		mov es, ax
		;-------user code--------
	;	clrscr

		mov cx, 2 
		loop1:
			mov al, 2
			mov ah, 2
			push ax
			mov al, 30 
			mov ah, 10 
			push ax
			mov al, 219
			push ax
			call moveRectangle
		loop loop1

		mov dx, 184fh
		sub dl, dl	
		setCur dl, dh

		;------------------------
		mov ax, 4c00h					;завершение работы приложения
		int 21h

	main endp
code ends

end main		;точка входа в программу
