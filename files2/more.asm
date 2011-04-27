include fslib\fs.asm
include numlib\num.asm
include string.asm

size = 1

stk segment stack 
	db 100h dup(?)
stk ends

data segment
	;---Constants---
	;---Variables---
	filename db 100 dup(0)
	f dw ?
	buf db ?
data ends

code segment
	assume ds:data, cs:code, ss:stk, es:data

	main proc				
		
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov es, ax				;es = ax
		;получение параметров 
		mov bx, 80h				;bx указывает на начало строки с параметрами "<длина строки> <параметры>"
		mov cl, [bx]
		sub ch, ch
		
		cmp cx, 0				;если параметров 0 - выходим
		jne _continue
			jmp _exit
		_continue:

		add bx,2				;копируем строку в filename
		lea bp, filename
		dec cx
		loop0:
			mov dl, [bx]
			mov es:[bp], dl
			inc bx
			inc bp
		loop loop0
		
		mov ax, data				;data сегментируется ds
		mov ds, ax
		;-------user code--------
		;чтение и вывод f
		openFile filename, f

		sub cx, cx
		loop1:
			readFile f, buf, size, ax
			charOut buf
			
			cmp buf, 10		;если встретился перенос строки
			jne _dont_inc
				inc cx
			_dont_inc:

			cmp cx, 23
			jl _dont_wait
				mov ah, 010h	
				int 16h
				sub cx, cx
			_dont_wait:

			cmp ax, size
			jl _exit1
		jmp loop1
		_exit1:
		newline

		closeFile f

		_exit:
		;------------------------
		mov ax, 4c00h
		int 21h

	main endp
code ends

end main		;точка входа в программу
