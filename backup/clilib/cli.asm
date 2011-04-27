.286
;Работа с консолью
extrn _setCur:far, _getCur:far, _attrCharOut:far, _setAttrBits:far, _clAttrBits:far, _getCur:far, _getChar:far

;------Constants-------
;цвета
BLACK equ 000
BLUE  equ 001
GREEN equ 010
CYAN  equ 011
RED   equ 100
PINK  equ 101
BROWN equ 110
GREY  equ 111
;----------------------

;очистка экрана
clrscr macro 
	pusha
	
	mov ax, 0600h
	mov bh, 07
	mov cx, 0000
	mov dx, 184fh
	int 10h

	popa
endm

;установка курсора в столбец col и строку line
setCur macro col, line
	push dx

	mov dl, col
	mov dh, line
	push dx
	call _setCur

	pop dx
endm

;получение координат курсора. Столбец записывается в байт col, а строка в байт line
getCur macro col, line
	push dx

	push dx
	call _getCur
	pop dx
	
	mov col, dl
	mov line, dh

	pop dx
endm

;вывод символа ch с аттрибутами
attrCharOut macro ch
	push dx

	mov dl, ch
	sub dh, dh
	push dx
	call _attrCharOut

	pop dx
endm

;установка цвета шрифта
setForeCol macro color
	push dx
	
	;сбрасываем биты
	mov dl, 11111000b
	push dx
	call _clAttrBits
	;устанавливаем
	mov dl, 00000&color&b
	push dx
	call _setAttrBits
	
	pop dx
endm

;установка цвета фона
setBackCol macro color
	push dx
	
	;сбрасываем биты
	mov dl, 10001111b
	push dx
	call _clAttrBits
	;устанавливаем
	mov dl, 0&color&0000b
	push dx
	call _setAttrBits
	
	pop dx
endm

;установка бита яркости цвета
setBright macro
	push dx
	
	mov dl, 00001000b
	push dx	
	call _setAttrBits

	pop dx
endm

;сброс бита яркости цвета
clBright macro
	push dx
	
	mov dl, 11110111b
	push dx	
	call _clAttrBits

	pop dx
endm

;включить мерцание
setBlink macro
	push dx
	
	mov dl, 10000000b
	push dx	
	call _setAttrBits

	pop dx
endm

;отключить мерцание
clBlink macro
	push dx
	
	mov dl, 01111111b
	push dx	
	call _clAttrBits

	pop dx
endm

;получить символ ch под курсором и его аттрибуты attr
getChar macro ch, attr
	push dx
	
	push dx
	call _getChar
	pop dx
	mov ch, dl
	mov attr, dh

	pop dx
endm
