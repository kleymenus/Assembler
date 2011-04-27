.286
code segment
	assume cs:code, ss:code, ds:code, es:code

	org 0		;переходим на начало программы
	begin equ $	;begin - константа содержащее адрес начала программы(смещение)
	org 100h	;перепрыгиваем PSP


	main: jmp start 
		old_int dd ?		;старый обработчик прерываний
		flag	dw 4242h	;флаг, признак того что резидент загружен

	;собственно код, который будет резидентным
	new_int proc far
		pushf
		pusha

		push cs	;загрузка ds
		pop ds	;

		;данные------------
		jmp _skip_data
			scr db 25*80 dup(0), 0
			fname db "screen.txt",0
		_skip_data:
		;-------------------

		in al, 60h	;читаем клавиатуру

		cmp al, 52h	;проверяем нажат ли insert
		jne _not_pressed
			;если нажат:
			
			;считываем содержимое экрана в массив 25x80
			sub dl, dl	;x
			sub dh, dh	;y
			sub di, di	;по массиву
			mov cx, 25
			loop1:
				push cx
				mov cx, 80
				loop2:
					;устанавливаем курсор в dl,dh
					mov ah, 02
					mov bh, 00
					int 10h

					mov ah, 09
					mov al, scr[di] ;выводим символ
					mov bh, 0
					mov bl, 00000111b
					mov cx, 1
					int 10h
					
					inc di
					inc dl
				loop loop2
				pop cx

				inc dh
			loop loop1
				
			;создаем файл	
			mov cl, 0
			lea dx, fname
			mov ah, 5bh
			int 21h		;ax - handler
			
			;запись в файл массива scr

			mov bx, ax
			push bx
			lea dx, scr
			mov cx, 25*80
			mov ah, 40h
			int 21h 
			
			;закрытие pop bx
			mov ah, 3eh
			int 21h

			;выходим
			popa
			popf
			iret
		_not_pressed:
			;если не зажат, то
			popa		;восстанавливаем регистры
			popf		;

			jmp cs:old_int	;и обрабатываем клавиатуру старым прерыванием	(просто переходим по адрессу старой функции)
	new_int endp

	code_len equ ($-begin)		;подсчитываем объем памяти занимаемый кодом
	
	start:
		mov ax, cs	;загрузка ds
		mov ds, ax

		;получение вектора прерывания;;;;;;;;;;;;;;;;;;;;;
		;in:	ah = 35h
		;	al = номер прерывания
		;out:	es:bx - адрес обработчика прерываний
		mov ah, 35h
		mov al, 09h	;09h - вывод строки
		int 21h		;теперь в bx находится адрес начала кода резидента, а в es - начало сегмента
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
		cmp es:[bx-2], 4242h		;проверяем, находится ли значение флага в памяти(т.е резидент загружен)
		jne _load_resident		;если нет, то загружаем резидент
			;если, резидент уже загружен, то выгружаем его

			push ds		;сохраняем значение ds в стеке
			
			;устанавливаем вектор прерывания старым значением;;;;;;;;;;;;;
			;in:	ah = 25h
			;	al = номер прерывания
			;	ds:dx = вектор прерывания: адресс программы обработки прерывания
			mov ah, 25h
			mov al, 09h	;в таблице прерываний заменим прерывание с номером 09h старым значением

			mov dx, es:[bx-4] ;ds = старшая половина двойного слова old_int		(почему нельзя обратиться напрямую к old_int?)
			mov ds, dx

			mov dx, es:[bx-6] ;dx = младшая половина old_int
			int 21h
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

			pop ds		;восстанавливаем ds
			
			;выходим
			mov ax, 4c00h
			int 21h

		_load_resident:	
			;если резидент не зугружен, то загружаем его		

			;сохраняем старое значение вектора прерываний
			mov word ptr old_int, bx
			mov word ptr old_int+2, es

			;устанавливаем вектор прерывания новым значением;;;
			mov ah, 25h
			mov al, 09h
			;в ds уже находится адрес сегмента кода
			lea dx, new_int
			int 21h
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


			;выходим и оставляем программу в памяти
			;in:	ah = 31h
			;	al = код выхода
			;	dx = объем памяти (в параграфах) занимаемой программой, которая будет находится в памяти
			mov ah, 31h
			mov al, 0
			mov dx, (code_len/16) + 1	;1 параграф - 16 байт
			int 21h
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
code ends
end main
