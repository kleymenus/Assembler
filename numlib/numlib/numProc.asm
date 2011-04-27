.286
public _charOut, _charIn, _unsignWordOut, _signWordOut, _signByteOut, _wordIn

aux_seg segment byte		;что делает параметр byte?
	assume cs:aux_seg

	;Здесь если передается параметр слово, а используется байт, то всегда берется младший байт

	;вывод символа
	_charOut proc far
		;usage:
		;push ch	;сh - это слово, младший байт которого - код символа
		;call _charOut
		;
		;BP|IP|CS|ch|...
		push bp
		mov bp, sp
		pusha

		mov dx, [bp+6]
		mov ah, 2
		int 21h
		
		popa
		pop bp
		ret 2
	_charOut endp

	;ввод символа
	_charIn proc far
		;usage:
		;push <something>
		;call _charIn
		;pop ch
		;
		;BP|IP|CS|ch|...
		push bp
		mov bp, sp
		pusha

		;считывание символа
		mov ah, 010h
		int 16h

		mov [bp+6], ax

		;вывод текущего символа
		mov dl, al
		mov ah, 2
		int 21h

		popa
		pop bp
		ret
	_charIn endp

	;вывод беззнакового слова
	_unsignWordOut proc far
		;usage
		;push x
		;call _unsignWordOut
		;
		;BP|IP|CS|x|...
		push bp
		mov bp, sp
		pusha
		
		mov ax, [bp+6]
		sub dx, dx
		mov bx, 10

		sub cx, cx
		loop1:
			div bx	;ax = ax div 10, dx = ax mod 10

			add dx, '0'	;получаем в dx код символа
			push dx		;записываем в стек, для того чтобы вывести число в обратном порядке

			sub dx, dx

			inc cx		;в cx - кол-во цифр
		cmp ax, 0
		jne loop1

		loop2:
			call _charOut	
		loop loop2	

		popa
		pop bp
		ret 2
	_unsignWordOut endp

	;вывод знакового слова
	_signWordOut proc far
		;usage
		;push x
		;call _signWordOut
		;
		;BP|IP|CS|x|...
		push bp
		mov bp, sp
		pusha

		mov ax, [bp+6]
		test ah, 10000000b
		jz _positive
			;вывод отрицательного числа
			mov bl, '-'
			push bx
			call _charOut

			neg ax
		_positive:
			;вывод положительного числа
			push ax
			call _unsignWordOut

		popa
		pop bp
		ret 2
	_signWordOut endp

	;вывод знакового байта
	_signByteOut proc far
		;usage:
		;push x
		;call _signByteOut
		;
		;BP|IP|CS|x|...
		push bp
		mov bp, sp
		pusha

		mov ax, [bp+6]	
		sub ah, ah

		test al, 10000000b
		jz _byte_positive
			;перевод байта в число для отрицательного случая	
			neg al
			neg ax
		_byte_positive:
			push ax
			call _signWordOut
			
		popa
		pop bp
		ret 2
	_signByteOut endp

	;ввод слова
	_wordIn proc far
		;usage
		;push <sthng>
		;call _wordIn
		;pop x
		;
		;BP|IP|CS|x|...
		push bp
		mov bp, sp
		pusha

		mov bx, 10
		sub ax, ax
		sub si, si			;знаковый флаг
		_wordIn_loop:
			push cx			;cl = getch()
			call _charIn
			pop cx
			sub ch, ch	

			cmp cl, 13		;выполнять, пока не нажат enter
			je _exit

			cmp cl, '-'		;проверяем на знак числа
			jne _unsigned
				mov si, 1		;если ввели минус, то число отрицательное
				jmp _wordIn_loop	;пропустим одну итерацию
			_unsigned:

			sub cl, '0'		;преобразовываем символ в число

			mul bx			;ax *= 10
			add ax, cx		;ax += cl
		jmp _wordIn_loop
		_exit:

		cmp si, 1
		jne _dont_set_sign
			neg ax		;устанавливаем знак
		_dont_set_sign:

		mov [bp+6], ax		;сохраняем результат

		popa
		pop bp
		ret
	_wordIn endp
aux_seg ends
end
