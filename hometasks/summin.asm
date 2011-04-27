include io.asm

stk segment stack 
	db 100h dup(?)
ends stk	

data segment
	;---Constants---
	s1 db "Insert a: $"
	s2 db "Insert b: $"
	s3 db "Insert c: $"
	;---Variables---
	b dw ?
	c dw ?
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
		mov dx, offset s1			;ввод ax
		outstr					;
		inint ax				;

		mov dx, offset s2			;ввод b
		outstr					;
		inint b 				;

		mov dx, offset s3			;ввод c
		outstr					;
		inint c 				;

		mov bx, ax				;bx - сумма всех чисел
		add bx, b				;
		add bx, c				;

		cmp ax,b				;сравнение ax и b
		jg ax_b		

		mov ax, b				;если a<b

	ax_b:						;если a>b
		cmp ax,c				;сравним ax,c 
		jg ax_c 
		
		mov ax,c				;если c>ax 

	ax_c:						;если ax>c
		sub bx,ax 				;вычистаем из суммы всех чисел максимальнное

		outint bx
		newline

		;------------------------
		finish					;завершение работы приложения

	main endp
ends code


end main		;точка входа в программу
