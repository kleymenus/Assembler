include clilib\cli.asm
include numlib\num.asm

MAXX equ 78 	;макс. координата x
MAXY equ 23	;макс. координата y
	
;---Wrappers
putPixel macro x, y
	push dx
	
	mov dl, x
	mov dh, y
	push dx
	call _putPixel

	pop dx
endm

drawPlate macro obj
	push dx
	
	mov dl, obj.x
	mov dh, obj.y
	push dx
	call _drawPlate

	pop dx
endm

drawPoint macro obj
	putPixel obj.x, obj.y
endm
;-----------

;---Structs
object struc
	x db 0
	y db 0
object ends
;---------

stk segment stack 
	db 100h dup(?)
stk ends

data segment
	;---Constants---
	;---Variables---
	plate1 object <0,0>
	point object <40,12>
	score db 0
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

	;_putPixel рисует точку с координатами x,y
	_putPixel proc
		;usage
		;push <x:y>
		;call _putPixel
		;
		;BP|IP|<x:y>|...
		push bp
		mov bp, sp
		pusha
		
		mov ax, [bp+4]	
		setCur al, ah		
		attrCharOut 219
		inc al
		setCur al, ah		
		attrCharOut 219

		popa
		pop bp
		ret 2
	_putPixel endp

	;Прорисовка платформы с координатами x,y
	;Платформа состоит из 5 пикселей
	_drawPlate proc
		;usage
		;push <x:y>
		;call _drawPlate
		;
		;BP|IP|<x:y>|...
		push bp
		mov bp, sp
		pusha
		
		mov ax, [bp+4]	
		mov cx, 5
		_drawPlate_loop:
			putPixel al, ah	
			inc ah
		loop _drawPlate_loop

		popa
		pop bp
		ret 2
	_drawPlate endp

	main proc				
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		mov es, ax
		;-------user code--------
		clrscr

		mov dl, 1	;dl- приращение координаты шарика по x
		mov dh, 1	;dh- приращение координаты шарика по y

		;игровой цикл
		_game_cycle:
			;-------обработка клавиатуры
			;читаем порт клавиатуры
			in ax, 60h

			;q -  выйти
			cmp al, 16
			jne _continue
				jmp _exit
			_continue:

			;стрелка вниз - plate1 вниз
			cmp ax, 336
			jne _dont_inc_bh
				inc plate1.y
			_dont_inc_bh:

			;стрелка вверх - plate1 вверх
			cmp ax, 328
			jne _dont_dec_bh
				dec plate1.y
			_dont_dec_bh:
			;---------------------------

			;-------движение point
			;удары о левую и правую платформы
			cmp point.x, MAXX	;если мяч достиг правого края
			je _right_edge

			cmp point.x, 0		;если мяч достиг левого края
			je _left_edge

			jmp _brk1
			_right_edge:
				neg dl
				jmp _brk1
			_left_edge:
				mov cl, point.y
				sub cl, plate1.y 	;сравниваем положение платформы и мячика

				;смотрим куда попал мяч
				cmp cl, 0
				je _01
				cmp cl, 1
				je _02
				cmp cl, 2
				je _02
				cmp cl, 3
				je _02
				cmp cl, 4
				je _03
				jmp _score_up

				_01:			;|*|_|_|_|_|
					add dh, -1
					jmp _brk2
				_02:			;|_|*|*|*|_|
					neg dh	
					jmp _brk2
				_03:			;|_|_|_|_|*|
					add dh, 1
					jmp _brk2
				_score_up:		;мимо площадки
					inc score
					jmp _brk2
				_brk2:

				neg dl		;меняем направление движения по x
				
				jmp _brk1
			_brk1:

			;если шарик достиг верхней или нижней стенки
			cmp point.y, 0
			jle _top_down
			cmp point.y, MAXY
			jge _top_down

			jmp _brk3
			_top_down:
				neg dh
				jmp _brk3
			_brk3:
			

			add point.x, dl
			add point.y, dh
			;----------------------

			;прорисовка
			drawPlate plate1
			drawPoint point
			;вывод счета
			setCur 20, 0
			unsignByteOut score

			;зедержка
			call sleep
			clrscr
		jmp _game_cycle
		_exit:

		;------------------------
		mov ax, 4c00h					;завершение работы приложения
		int 21h

	main endp
code ends

end main		;точка входа в программу
