;библиотека работы с графикой
extrn _plot:far, _line:far, _circle:far, _fillscr:far

;инициализация
initGraph macro 
	mov ah, 0
	mov al, 13h
	int 10h

	push 0a000h
	pop es
endm

;выход из графическог режима
exitGraph macro
	mov ah, 0
	mov al, 10h
	int 10h
endm

plot macro x,y, color
	push dx

	push x
	push y
	sub dh, dh
	mov dl, color
	push dx
	call _plot

	pop dx
endm

line macro x0, y0, x1, y1, color
	push dx

	mov dl, color
	push dx
	push x0
	push y0
	push x1
	push y1
	call _line

	pop dx
endm

fillscr macro color
	push dx
	
	mov dl, color
	push dx
	call _fillscr

	pop dx
endm

circle macro x0, y0, r, color
	push dx
	
	push x0
	push y0
	push r
	mov dl, color
	push dx
	call _circle

	pop dx
endm
