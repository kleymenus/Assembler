.286

MAXLEN equ 255

;определение строки с именем nm
strInit macro nm
	nm db MAXLEN+1 dup('$')
endm

;вывод строки
strOut macro s
	push dx
	push ax

	lea dx, s
	mov ah, 09h
	int 21h

	pop ax	
	pop dx
endm

;ввод строки
strIn macro s
	pusha

	;ввод строки
	mov ah, 3fh
	sub bx, bx
	mov cx, MAXLEN
	lea dx, s
	int 21h

	;удаление 13,10
	lea bx, s
	add bx, ax
	mov [bx-2], '$'
	mov [bx-1], '$'

	popa
endm


;получение позиции первого вхождения символа ch в строку str
;result имеет значение от 0 до strlen-1
;не использовать в качестве праметров cx, si, ax, di
strPos macro s, ch, result
	push di
	push ax
	push si
	push cx

	cld

	lea di, s
	mov al, ch
	mov cx, MAXLEN
	repne scasb
	
	lea si, s
	sub di, si
	dec di
	mov result, di

	pop cx
	pop si
	pop ax
	pop di
endm

;получение кол-ва символов в строке, result - 2 байта и не si, di, ax, cx
strLen macro s, result
	strPos s, '$', result
endm

;замена i-того символа(нумерация с 0) на символ ch в строке s
strRepl macro s, i, ch
	push di
	
	lea di, s
	add di, i
	mov [di], ch

	pop di
endm

;Удаление i-того символа из строки s
strDel macro s, i
	push si
	push di
		
	cld			

	lea di, s
	add di, i

	mov si, di
	inc si

	mov cx, MAXLEN
	sub cx, i
	dec cx

	rep movsb

	pop di
	pop si
endm

;Добавление нового символа ch в строку после i-тым символом(строка должна быть необходимого размера)
strAdd macro s, i, ch
	push si
	push di

	std

	lea di, s
	add di, MAXLEN
	dec di

	mov si, di
	dec si

	mov cx, MAXLEN
	sub cx, i
	dec cx

	rep movsb

	mov si, i
	inc si
	strRepl s, si, ch

	pop di
	pop si
endm

;Конкатенация строка s1 и s2 в s1, т.е s1 = s1+s2
strCat macro s1, s2
	pusha

	cld

	lea di, s1
	strLen s1, bx
	add di, bx

	lea si, s2

	mov cx, MAXLEN
	sub cx, bx
	
	rep movsb

	popa
endm

;Копирование из s2 в s1
strCopy macro s1, s2
	pusha

	cld

	lea di, s1
	lea si, s2

	mov cx, MAXLEN

	rep movsb

	popa
endm

;перевод строки из формата asciiz
convert macro s
	pusha
	strPos s, 0, bx
	strRepl s, bx, '$'
	popa
endm
