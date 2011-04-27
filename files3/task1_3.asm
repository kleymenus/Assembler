include fslib\fs.asm
include numlib\num.asm
include string.asm

;чтение слова из файла 
;eof = 1, если файл закончился и 0 иначе
readLine macro handler, buf, eof
	push dx

	push handler
	lea dx, buf
	push dx
	call _readLine
	pop eof

	pop dx
endm

stk segment stack 
	db 100h dup(?)
stk ends

data segment
	;---Constants---
	;---Variables---
	filename1 db "f.txt",0
	filename2 db "g.txt",0
	f dw ?
	g dw ?
	buf db 256 dup('$')
	tmp db ?
data ends

code segment
	assume ds:data, cs:code, ss:stk, es:data

	_readLine proc 
		;usage:
		;push <handler>
		;push <buf>
		;call readLine
		;pop <eof>
		;
		;BP|IP|buf|handler|...
		push bp
		mov bp, sp
		pusha

		;чтение слов
		mov di, [bp+4]
		mov cx, [bp+6]

		;чтение слова до переноса строки
		_readLine_loop1:
			readFile cx, tmp, 1, ax

			cmp ax, 0			;если файл закончился
			je _readLine_eof

			cmp tmp, 10
			je _readLine_exit1

			mov bl, tmp
			mov [di], bl
			inc di
		jmp _readLine_loop1
		_readLine_exit1:
		mov [bp+6], 0

		jmp _readLine_brk
		_readLine_eof:	
			mov [bp+6], 1
		_readLine_brk:

		mov [di], '$'		;установка символа конца строки
		
		popa
		pop bp
		ret 2
	_readLine endp

	main proc				
		
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		mov es, ax
		;-------user code--------
		openFile filename1, f
		openFile filename2, g
		
		loop1:
			readLine f, buf, ax	;читаем строку

			cmp buf, '0'		;проверка первого символа на цифру
			jl _skip
			cmp buf, '9'
			jg _skip
				strOut buf	;выводим на экран строки с первой цифрой
				newline
				jmp _brk
			_skip:
				strLen buf, bx	;остальные записываем в g		
				writeFile g, buf, bx
				mov tmp, 10
				writeFile g, tmp, 1
			_brk:

			cmp ax, 1
			je _eof
		jmp loop1
		_eof:
		
		closeFile f
		closeFile g
		;------------------------
		mov ax, 4c00h
		int 21h

	main endp
code ends

end main		;точка входа в программу
