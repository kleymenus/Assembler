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
	str1 db "Insert list1: $"
	str2 db "Insert list2: $"
	str3 db "New list: $"
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

		;ввод списка 2
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

		;поиск максимального эл-та списка 1
		;в ax - макс. эл-т
		mov di, list1
		mov ax, es:[di].info
		loop3:
			cmp di, NIL
			je _exit3

			cmp ax, es:[di].info	
			jge _skip3
				mov ax, es:[di].info
			_skip3:

			mov di, es:[di].next
		jmp loop3
		_exit3:

		;поиск позиции максимального эл-та
		;di - поз. макс. эл-та
		mov di, list1
		loop4:
			cmp es:[di].info, ax
			je _exit4

			mov di, es:[di].next
		loop loop4
		_exit4:

		;вставка списка2
		push es:[di].next
		
		push list2		;es:[di].next = list2
		pop es:[di].next

		;ищем адрес di последнего эл-та списка2
		loop5:
			cmp es:[di].next, NIL
			je _exit5

			mov di, es:[di].next
		loop loop5
		_exit5:
		pop es:[di].next		;вставляем остальную часть списка1 в конец списка 2

		;вывод списка
		newline
		strOut str3
		newline

		mov di, list1
		loop6:
			cmp di, NIL
			je _exit6

			unsignWordOut es:[di].info
			newline

			mov di, es:[di].next
		jmp loop6
		_exit6:

		;------------------------
		mov ax, 4c00h
		int 21h

	main endp
code ends

end main		;точка входа в программу
