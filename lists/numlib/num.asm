;здесь описаны макросы вызывающие функции из numProc.asm

extrn _charOut:far, _charIn:far, _unsignWordOut:far, _signWordOut:far, _signByteOut:far, _wordIn:far

;вывод символа ch
charOut macro ch
	push dx

	mov dl, ch
	push dx
	call _charOut

	pop dx
endm

;ввод символа в ch
charIn macro ch
	push dx

	push dx
	call _charIn
	pop dx

	mov ch, dl

	pop dx
endm

;Перевод строки
newline macro 
	charOut 13
	charOut 10
endm

;вывод беззнакового слова
unsignWordOut macro x
	push x
	call _unsignWordOut
endm

;вывод беззнакового байта
unsignByteOut macro x
	push dx
	
	mov dl, x
	sub dh, dh
	push dx
	call _unsignWordOut

	pop dx
endm

;вывод знакового слова
signWordOut macro x
	push x
	call _signWordOut
endm

;вывод знакового байта
signByteOut macro x
	push dx

	mov dl, x
	push dx
	call _signByteOut
	
	pop dx
endm

;ввод слова
wordIn macro x
	push x
	call _wordIn
	pop x
endm

;ввод байта
byteIn macro x
	push dx

	wordIn dx
	mov x, dl

	pop dx
endm
