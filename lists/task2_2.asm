include numlib\num.asm
include string.asm

NIL equ 0
HEAP_SIZE equ 100

node struc 
	info db ?
	next dw ?
node ends

heap segment 
	heap_ptr dw ?
	db 3*HEAP_SIZE dup(?)
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
		mov si, 3*HEAP_SIZE-1
		_init_loop1:
			mov es:[si].next, bx	
			mov bx, si
			sub si, 3
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

		charIn al
		newline
		cmp al, '.'
		je _exit

		call new
		mov es:[di].info, al
		mov list1, di

		loop1:
			mov bx, di

			CharIn al
			newline
			cmp al, '.'
			je _exit

			call new
			mov es:[di].info, al
			mov es:[bx].next, di
		loop loop1
		_exit:
		mov es:[di].next, NIL

		;обработака
		;проверка начала
		mov bx, list1
		mov si, es:[bx].next

		;проверка на цифру
		cmp es:[bx].info, '0' 
		jl _skip4
		cmp es:[bx].info, '9'
		jg _skip4
		;проверка на не букву
		cmp es:[si].info, 'A'
		jl _not_skip4
		cmp es:[si].info, 'z'
		jg _not_skip4
		jmp _skip4
			_not_skip4:
			call new
			mov es:[di].info, '*'
			mov es:[di].next, bx
			mov list1, di
		_skip4:

		;остальные случаи
		mov bx, list1
		mov si, es:[bx].next
		mov di, es:[si].next

		mov bx, si
		mov si, di
		mov di, es:[di].next
		loop2:
			cmp di, NIL
			je _exit2

			;проверка на цифру
			cmp es:[si].info, '0' 
			jl _skip2
			cmp es:[si].info, '9'
			jg _skip2
			;проверка на не букву
			cmp es:[di].info, 'A'
			jl _not_skip2
			cmp es:[di].info, 'z'
			jg _not_skip2
			jmp _skip2
				_not_skip2:
				push di	
				call new
				mov es:[di].info, '*'
				push es:[bx].next
				pop es:[di].next
				mov es:[bx].next, di
				pop di
			_skip2:


			mov bx, si
			mov si, di
			mov di, es:[di].next
		jmp loop2
		_exit2:

		;вывод списка
		newline
		strOut str2
		newline

		mov di, list1
		loop3:
			cmp di, NIL
			je _exit3

			charOut es:[di].info
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
