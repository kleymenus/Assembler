include string.asm
include io.asm

stk segment stack 
	db 100h dup(?)
stk ends

data segment
	;---Constants---
	str1 db "Insert string: $"
	str2 db "Len of string: $"
	str3 db "Insert char: $"
	str4 db "Position(from 0) this char : $"
	str5 db "Insert position and char: $"
	str6 db "Insert position, which you need delete: $"
	str7 db "Insert position and char for adding char: $"
	str8 db "s1 + s2: $"
	;---Variables---
	strInit s1
	strInit s2
data ends

code segment
	assume ds:data, cs:code, ss:stk, es:data

	main proc				
		
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		mov es, ax
		;-------user code--------
		strOut str1
		strIn s1
		strOut s1
		newline

		newline
		strLen s1, dx
		strOut str2
		outint dx
		newline

		newline
		strOut str3
		inch bl
		strOut str4
		strPos s1, bl, dx
		outint dx
		newline

		newline
		strOut str5
		inint dx
		inch bl
		strRepl s1, dx, bl
		strOut s1
		newline

		newline
		strout str6
		inint dx
		strDel s1, dx
		strOut s1
		newline

		newline
		strout str7
		inint dx
		inch bl
		strAdd s1, dx, bl
		strOut s1
		newline
	
		newline
		strout str1
		strin s1
		strout str1
		strin s2
		strout str8
		strCat s1, s2
		strout s1
		newline

		newline
		strout str1
		strIn s1
		strout str1
		strIn s2
		strCopy s1, s2
		strout s1
		newline

		;------------------------
		mov ax, 4c00h
		int 21h

	main endp
code ends

end main		;точка входа в программу
