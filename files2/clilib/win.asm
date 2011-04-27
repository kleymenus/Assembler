;-----------WINDOWS--------------
;Структура окна
win struc
	x db 0
	y db 0
	w db 0
	h db 0
	titl db 16 dup('$')
	text db 256 dup('$')
win ends

;Макросы для работы с окнами

;Создание окна
winNew macro win
	local loop1, loop2, loop3, loop4
	pusha
	;al - текущий x
	;ah - текущий y

	;очистка места для окна
	mov ax, 0600h
	mov bh, 07
	mov cl, win.x
	mov ch, win.y

	mov dl, win.x
	add dl, win.w

	mov dh, win.y
	add dh, win.h
	int 10h


	;прорисовка верхнего края
	mov al, win.x
	mov ah, win.y
	setBright
	setForeCol %GREY
	setBackCol %GREEN

	setCur al, ah
	attrCharOut ' '
	inc al
	setCur al, ah	
	;вывод заголовка
	strlen win.titl, dx 
	
	lea di, win.titl
	mov cl, dl
	sub ch, ch
	loop1:
		attrCharOut [di]
		inc di

		inc al
		setCur al, ah
	loop loop1

	mov cl, win.w
	sub cl, dl
	dec cl
	loop2:
		attrCharOut ' '
		inc al
		setCur al, ah
	loop loop2

	;прорисовка левого и правого края
	setForeCol %GREEN
	setBackCol %BLACK

	mov al, win.x
	mov ah, win.y
	inc ah
	mov cl, win.h
	sub cl, 2

	setCur al, ah
	loop3:
		attrCharOut 179	;левый край	
		add al, win.w
		dec al
		setCur al, ah
		attrCharOut 179	;правый край
		sub al, win.w
		inc al

		inc ah
		setCur al, ah
	loop loop3

	;прорисовка нижнего края
	mov al, win.x
	mov ah, win.y

	add ah, win.h
	dec ah
	setCur al, ah
	attrCharOut 192	;левый нижний угол

	inc al
	setCur al, ah

	mov cl, win.w
	sub cl, 2
	loop4:
		attrCharOut 196	;нижний край
		inc al
		setCur al, ah
	loop loop4
	attrCharOut 217	;правый нижний угол

	mov dx, 184fh	;установка курсора вниз
	sub dl, dl
	setCur dl, dh

	popa
endm

;Вывод текста внутри  окна
winTextOut macro win
	local loop1, _dont_carry, _brk
	pusha

	mov al, win.x
	mov ah, win.y
	inc al
	inc ah
	setCur al, ah

	strlen win.text, dx
	mov cx, dx
	lea di, win.text

	mov bl, win.w	;ширина экрана без рамок
	sub bl, 2
	mov bh, 1	;номер выводимого символа на строке
	loop1:
		attrCharOut [di]
		inc di

		cmp bh, bl
		jl _dont_carry
			mov al, win.x
			inc al
			inc ah
			mov bh,1
			jmp _brk
		_dont_carry:
			inc al
			setCur al, ah
		_brk:
		inc bh
	loop loop1

	mov dx, 184fh	;установка курсора вниз
	sub dl, dl
	setCur dl, dh

	popa
endm
