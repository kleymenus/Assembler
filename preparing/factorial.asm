include io.asm

stk segment stack 
	db 100h dup(?)
stk ends

data segment
	;---Constants---
	str1 db "Insert number: $"
	str2 db "Factorial: $"
	;---Variables---

data ends

code segment
	assume ds:data, cs:code, ss:stk

	factorial proc
		;al - аргумент		        |1, al<=1
		;dx - значение факториала f(al)=<
		;				|al*f(al-1), al>1

		cmp al, 1
		ja _recursion
			;не рекрсивная ветвь
			mov dx, 1
			ret
		_recursion:
			push ax

			dec al		;
			call factorial	;	dx = f(al-1)
			sub ah, ah	;

			inc al		;
			mul dx		;	dx - f(al-1)*al
			mov dx, ax	;
			
			pop ax
			ret
	factorial endp

	main proc				
		
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		;-------user code--------
		lea dx, str1
		outstr

		inint ax

		lea dx, str2
		outstr
		call factorial
		outword dx

		newline
		

		;------------------------
		finish					;завершение работы приложения

	main endp
code ends

end main		;точка входа в программу
