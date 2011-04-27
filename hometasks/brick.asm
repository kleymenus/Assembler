include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert size of hole (MxN)$"
	s2 db "Insert size of brick (AxBxC)$"
	s3 db "Yes$"
	s4 db "No$"
	;---Variables---
	m db ?
	n db ?
	a db ?
	b db ?
	c db ?
ends data

code segment
	main proc				
		assume ds:data, cs:code, ss:stk		;сопоставление сегментам указанных регистров
		
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		;-------user code--------
		mov dx, offset s1			;
		outstr					;вводим размер дыры
		newline					;
		inint ax				;
		mov m, al				;
		sub ax,ax				;
		inint ax				;
		mov n, al				;
		sub ax,ax				;

		mov dx, offset s2			;
		outstr 					;
		newline					;
		inint ax				;ввод размера кирпича
		mov a, al				;
		sub ax,ax				;
		inint ax				;
		mov b, al				;
		sub ax,ax				;
		inint ax				;
		mov c, al				;
		sub ax,ax				;

		sub dx,dx

		;поиск двух минимальных измерений (здесь это bl и bh)
		mov al, a 
		cmp al, b
		jg _a_b
		mov bl, a		;если a<b, a - первый минимальный

		mov al, b		
		cmp al, c 
		jg _a_c
		mov bh, b		;если b<c, b - второй минимальный
		jmp _break

	_a_b:				;если a>b
		mov bl, b		;b - первый минимальный
		cmp al, c
		jg _a_c			
		mov bh, a		;елси a<c - a - втор минимальный	
		jmp _break
	_a_c:				;если a>c
		mov bh, c		;то с - второй минимальный
		jmp _break
	_break:

		;пусть в al будет ширина дыры, в ah - длина
		mov al, m	
		cmp al, n
		jg _m_n
		mov ah, n		;есди m<n
		jmp _break2

	_m_n:				;если m>n
		mov al, n
		mov ah, m
	_break2:

		;оперделения прохождения объекта

		cmp bl, al
		jg _not	
		cmp bh, ah		;если bl<=al
		jg _not
		mov dx, offset s3	;и если bh<=ah
		outstr 			;выводим сообщение что кирпич проходит
		jmp _exit

	_not:
		mov dx, offset s4
		outstr
	_exit:
		newline

		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
