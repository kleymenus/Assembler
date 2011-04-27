include clilib\cli.asm
include numlib\num.asm
include string.asm
include clilib\win.asm

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
		mov es, ax
		;-------user code--------
		;(al, ah) - текущие координаты
		
		;найдем разницу между строчными и заглавными буквами
		mov dl, 'a'
		sub dl, 'A'
		
		mov cx, 25
		sub ah, ah
		loop1:
			sub al, al

			push cx
			mov cx, 80
			loop2:
				setCur al, ah	;устанавливаем курсор
				getChar bl, bh	;получаем символ bl

				cmp bl, 'a'
				jl _dont_replace
				cmp bl, 'z'
				jg _dont_replace
					sub bl, dl	
					attrCharOut bl
				_dont_replace:

				inc al
			loop loop2
			pop cx

			inc ah
		loop loop1
		
		;------------------------
		mov ax, 4c00h					;завершение работы приложения
		int 21h

	main endp
code ends

end main		;точка входа в программу
