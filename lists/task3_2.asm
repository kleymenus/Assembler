include numlib\num.asm
include string.asm

NIL equ 0
HEAP_SIZE equ 100

node struc 
	info dw ?
	next dw ?
node ends

heap segment 
	heap_ptr dw ?
	dd HEAP_SIZE dup(?)
heap ends

stk segment stack 
	db 100h dup(?)
stk ends

data segment
	;---Constants---
	str1 db "Insert n: $"
	str2 db "Insert array: $"
	str3 db "New list: $"
	;---Variables---
	list1 dw ?
	a dw 100 dup(?)
	n db ?
data ends

code segment
	assume ds:data, cs:code, ss:stk

	;инициализация кучи
	initHeap proc
		push si
		push cx
		push bx

		mov cx, heap
		mov es, cx

		mov bx, NIL
		mov cx, HEAP_SIZE
		mov si, 4*HEAP_SIZE-2
		_init_loop1:
			mov es:[si].next, bx	
			mov bx, si
			sub si, 4
		loop _init_loop1

		mov es:heap_ptr, bx

		pop bx
		pop cx
		pop si
		ret
	initHeap endp

	;new возращает в di адрес выделенной области памяти
	;либо возращает NIL
	new proc
		mov di, es:heap_ptr		
		cmp di, NIL
		je _new_skip
			push es:[di].next
			pop es:heap_ptr
		_new_skip:
		ret
	new endp

	;возращает в ССП область памяти, адрес которой хранится в di
	dispose proc
		push es:heap_ptr
		pop es:[di].next
		mov es:heap_ptr, di
		ret
	dispose endp

	main proc				
		
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		;-------user code--------
		call initHeap
		
		;ввод массива
		strOut str1
		byteIn n
		
		newline
		strOut str2
		newline

		mov cl, n
		sub ch, ch

		sub si, si
		loop1:
			wordIn a[si]	
			newline
			add si, 2
		loop loop1

		;преобразование массива в список
		sub si, si

		call new
		push a[si]
		pop es:[di].info
		mov list1, di
		add si, 2

		mov cl, n
		dec cl
		loop2:
			mov bx, di

			call new
			push a[si]
			pop es:[di].info
			mov es:[bx].next, di

			add si, 2
		loop loop2
		mov es:[di].next, NIL

		;вывод списка
		newline
		strOut str3
		newline

		mov di, list1
		loop3:
			cmp di, NIL
			je _exit3

			unsignWordOut es:[di].info
			newline

			mov di, es:[di].next
		jmp loop3
		_exit3:

		;------------------------
		mov ax, 4c00h
		int 21h

	main endp
code ends

end main		;точка входа в программу
