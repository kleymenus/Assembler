include numlib\num.asm
include clilib\cli.asm
include string.asm

attrStrOut macro s1
	push dx

	lea dx, s1
	push dx
	call _attrStrOut

	pop dx
endm

dta_struc struc
	disk db ?
	pattern db 11 dup(0)
	attr db 0
	num dw ?
	cluster dw ?
		db 4 dup(?)
	found_attr db ?
	time dw ?
	date dw ?
	filesize dd ?
	filename db 13 dup(0)
		 db 0
dta_struc ends

stk segment stack 
	db 100h dup(?)
stk ends

data segment
	;---Constants---
	;---Variables---
	dta dta_struc <>
	pat db "*.*",0
data ends

code segment
	assume ds:data, cs:code, ss:stk, es:data

	_attrStrOut proc
		;usage:
		;push <str>
		;call _attrStrOut
		;
		;BP|IP|str|...
		push bp
		mov bp, sp
		push di
		push ax

		getCur al, ah

		mov di, [bp+4]
		_attrStr_loop1:
			cmp [di], '$'	
			je _attrStr_exit1

			attrCharOut [di]
			inc al
			setCur al, ah

			inc di
		jmp _attrStr_loop1
		_attrStr_exit1:
		
		pop ax	
		pop di
		pop bp
		ret 2
	_attrStrOut endp

	main proc				
		
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		mov es, ax
		;-------user code--------
		;регистрация области dta
		mov ah, 1ah
		lea dx, dta
		int 21h	

		;поиск файла
		mov ah, 4eh
		mov cl, 11111111b	;все типы файлов
		lea dx, pat
		int 21h

		convert dta.filename
		strOut dta.filename
		newline

		setForeCol %GREY

		sub cx, cx		;счетчик для контролирования подачи вывода
		loop1:
			mov ah, 4fh
			int 21h
			jnc _continue	;если cf=1 - выходим
				jmp _exit1
			_continue:

			cmp cx, 10		;если вывело 10 строк, то
			jl _skip1		;ожидать нажатие клавиши для продолжения вывода
				mov ah, 010h	
				int 16h
				sub cx, cx
			_skip1:

			;вывод имени файла
			convert dta.filename	;конвертируем имя файла в ASCII

			mov al, dta.found_attr	;проверка на директорию
			test al, 00010000b
			jz _not_dir
				setForeCol %BLUE
				attrStrOut dta.filename
				setForeCol %GREY
				jmp _brk1
			_not_dir:
				attrstrOut dta.filename
			_brk1:

			charOut 9

			;вывод даты последнего изменения
			mov ax, dta.date		;вывод дня
			and ax, 0000000000011111b  
			unsignByteOut al

			charOut '-'

			mov ax, dta.date		;месяц
			and ax, 0000000111100000b
			shr ax, 5
			unsignByteOut al

			charOut '-' 

			mov ax, dta.date		;год c 1980
			and ax, 1111111000000000b
			shr ax, 9

			add ax, 1980		;настоящий год
			unsignWordOut ax

			charOut 9
			;вывод времени
			mov ax, dta.time	;часы
			and ax, 1111100000000000b
			shr ax, 11 
			unsignByteOut al

			charOut ':'

			mov ax, dta.time	;минуты
			and ax, 0000011111100000b
			shr ax, 5
			unsignByteOut al

			charOut ':'

			mov ax, dta.time	;секунды
			and ax, 0000000000011111b
			unsignByteOut al


			inc cx
			newline
		jmp loop1
		_exit1:

		;------------------------
		mov ax, 4c00h				;завершение работы приложения

	main endp
code ends

end main		;точка входа в программу
