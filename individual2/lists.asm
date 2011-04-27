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
	str3 db "List1:$"
	str4 db "List2:$"
	str5 db "Aver between positive: $"
	str6 db "Aver between parity: $"
	str7 db "Exception: no positive elements in list1$"
	str8 db "Exception: no parity elements in list1$"
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

		;---------ввод списка1
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

		;----------ввод списка2
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


		;поиск среднего арифмитического среди пол. эл-тов списка1
		sub ax, ax	;сумма
		sub bx, bx	;кол-во
	
		mov di, list1
		loop3:
			cmp di, NIL
			je _exit3
			
			cmp es:[di].info, 0	;проверяем на положительность
			jle _skip3
				add ax, es:[di].info	
				inc bx
			_skip3:

			mov di, es:[di].next
		jmp loop3
		_exit3:
		
		;возможно пол. эл-тов нету
		cmp bx, 0
		jne _skip_except1
			jmp except1
		_skip_except1:

		sub dx, dx
		div bx
		;ax - среднее арифмитическое пол. эл-тов
		strOut str5
		signWordOut ax
		newline

		
		;удаление из списка2 всех эл-тов больших ax
		mov bx, list2
		mov di, es:[bx].next
		loop4:
			cmp di, NIL
			je _exit4
			
			cmp es:[di].info, ax	
			jle _skip4
				push es:[di].next
				pop es:[bx].next

				push es:[di].next
				call dispose
				pop di

				jmp loop4
			_skip4:

			mov bx, di
			mov di, es:[di].next
		jmp loop4
		_exit4:

		;обработка первого эл-та
		mov di, list2
		cmp es:[di].info, ax	
		jle _skip
			push es:[di].next
			pop list2
			call dispose
		_skip:


		;поиск в списке1 среднего ариф. четных элементов
		sub ax, ax	;сумма
		sub bx, bx	;кол-во
	
		mov di, list1
		loop5:
			cmp di, NIL
			je _exit5
			
			test es:[di].info, 1b
			jnz _skip5
				add ax, es:[di].info	
				inc bx
			_skip5:

			mov di, es:[di].next
		jmp loop5
		_exit5:

		;возможно четных эл-тов нету
		cmp bx, 0
		jne _skip_except2
			jmp except2
		_skip_except2:

		idiv bl
		sub ah, ah
		cbw		;al->ax
		;ax - среднее четных эл-тов
		strOut str6
		signWordOut ax
		newline

		;дулирование эл-тов меньших ax в списке2 
		mov di, list2
		loop6:
			cmp di, NIL
			je _exit6

			cmp es:[di].info, ax
			jge _skip6
				mov bx, di

				call new
				push es:[bx].info
				pop es:[di].info
				push es:[bx].next
				pop es:[di].next
				mov es:[bx].next, di
			_skip6:

			mov di, es:[di].next
		jmp loop6
		_exit6:


		;вывод списка1
		newline
		strOut str3
		newline

		mov di, list1
		loop7:
			cmp di, NIL
			je _exit7

			signWordOut es:[di].info
			newline

			mov di, es:[di].next
		jmp loop7
		_exit7:
		newline
	
		;вывод списка2
		newline
		strOut str4
		newline

		mov di, list2
		loop8:
			cmp di, NIL
			je _exit8

			signWordOut es:[di].info
			newline

			mov di, es:[di].next
		jmp loop8
		_exit8:

		jmp _brk
		except1:
			strOut str7
			jmp _brk
		except2:
			strOut str8
		_brk:

		newline

		;------------------------
		mov ax, 4c00h
		int 21h

	main endp
code ends

end main		;точка входа в программу
