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
	win1 win <2,1, 10, 7,"Hi$","world$">
	win2 win <30,4, 15, 5,"Test$","Hello fucking world$">
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
		clrscr

		_main_cycle:
			clrscr
			winNew win2
			winTextOut win2
			inc win2.x

			;sleep 1
			mov cx, 30000
			loop1:
				nop
			loop loop1
		jmp _main_cycle

		;------------------------
		mov ax, 4c00h					;завершение работы приложения
		int 21h

	main endp
code ends

end main		;точка входа в программу
