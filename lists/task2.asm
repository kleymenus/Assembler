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
	str1 db "Insert list: $"
	str2 db "New list: $"
	;---Variables---
	list1 dw ?
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
		;ввод списка
		;bx - указывает на предыдущий эл-т, di - на текущий
		strOut str1
		newline

		wordIn ax
		newline
		cmp ax, 0
		je _exit

		call new
		mov es:[di].info, ax
		mov list1, di

		loop1:
			mov bx, di

			wordIn ax
			newline
			cmp ax, 0
			je _exit

			call new
			mov es:[di].info, ax
			mov es:[bx].next, di
		loop loop1
		_exit:
		mov es:[di].next, NIL

		;поиск наибольшего значения 
		mov di, list1
		mov cx, es:[di].info	;cx - наибольшее
		loop2:
			cmp di, NIL
			je _exit2

			cmp cx, es:[di].info	
			jge _skip
				mov cx, es:[di].info
			_skip:

			mov di, es:[di].next
		jmp loop2
		_exit2:

		;вставка половины наибольшего значения
		sub dx, dx
		mov ax, cx	;cx - наиб, ax - половина наибольшего
		mov bx, 2
		div bx

		mov di, list1
		loop3:
			cmp di, NIL
			je _exit3

			cmp cx, es:[di].info
			jne _skip2
				mov bx, di
				
				call new
				mov es:[di].info, ax
				push es:[bx].next
				pop es:[di].next
				
				mov es:[bx].next, di
			_skip2:

			mov di, es:[di].next
		jmp loop3
		_exit3:

		;вывод списка
		newline
		strOut str2
		newline

		mov di, list1
		loop4:
			cmp di, NIL
			je _exit4

			unsignWordOut es:[di].info
			newline

			mov di, es:[di].next
		jmp loop4
		_exit4:

		;------------------------
		mov ax, 4c00h
		int 21h

	main endp
code ends

end main		;точка входа в программу
