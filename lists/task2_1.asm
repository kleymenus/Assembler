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
	str1 db "Insert list 1: $"
	str2 db "Insert list 2: $"
	str3 db " belong list 2$"
	str4 db " not belong list 2$"
	;---Variables---
	list1 dw ?
	list2 dw ?
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
		;ввод списка 1
		strOut str1
		newline

		wordIn ax
		newline
		cmp ax, 0
		je _exit1

		call new
		mov es:[di].info, ax
		mov list1, di

		loop1:
			mov bx, di

			wordIn ax
			newline
			cmp ax, 0
			je _exit1

			call new
			mov es:[di].info, ax
			mov es:[bx].next, di
		loop loop1
		_exit1:
		mov es:[di].next, NIL

		mov dx, es:[di].info	;dx - последний эл-т списка 1

		;ввод списка 2
		newline
		strOut str2
		newline

		wordIn ax
		newline
		cmp ax, 0
		je _exit2

		call new
		mov es:[di].info, ax
		mov list2, di

		loop2:
			mov bx, di

			wordIn ax
			newline
			cmp ax, 0
			je _exit2

			call new
			mov es:[di].info, ax
			mov es:[bx].next, di
		loop loop2
		_exit2:
		mov es:[di].next, NIL


		;проверка принадлежности dx списку 2
		mov bl, 0	;bl - флаг
		mov di, list2
		loop3:
			cmp di, NIL
			je _exit3

			cmp dx, es:[di].info	;сравниваем эл-т с dx
			jne _skip3
				mov bl, 1
			_skip3:

			mov di, es:[di].next
		jmp loop3
		_exit3:

		;вывод результата
		unsignWordOut dx

		cmp bl, 1
		je _belong
			strOut 	str4
			jmp _brk
		_belong:
			strOut str3
		_brk:
		newline

		;------------------------
		mov ax, 4c00h
		int 21h

	main endp
code ends

end main		;точка входа в программу
