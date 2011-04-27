include fslib\fs.asm
include numlib\num.asm
include string.asm

;чтение слова из файла 
;eof = 1, если файл закончился и 0 иначе
readWord macro handler, buf, eof
	push dx

	push handler
	lea dx, buf
	push dx
	call _readWord
	pop eof

	pop dx
endm

stk segment stack 
	db 100h dup(?)
stk ends

data segment
	;---Constants---
	;---Variables---
	filename db "txt",0
	f dw ?
	buf db 30 dup('$')
	tmp db ?
	sample db "ab"
data ends

code segment
	assume ds:data, cs:code, ss:stk, es:data

	_readWord proc 
		;usage:
		;push <handler>
		;push <buf>
		;call readWord
		;pop <eof>
		;
		;BP|IP|buf|handler|...
		push bp
		mov bp, sp
		pusha

		;чтение слов
		mov di, [bp+4]
		mov cx, [bp+6]

		;пропуск первых пробелов и переносов строки
		_readWord_loop1:
			readFile cx, tmp, 1, ax	

			cmp ax, 0			;если файл закончился
			je _readWord_eof

			cmp tmp, ' '
			jne _readWord_exit1

			cmp tmp, 10
			jne _readWord_exit1
		jmp _readWord_loop1
		_readWord_exit1:
		mov bl, tmp
		mov [di], bl
		inc di
		;чтение слова до пробела
		_readWord_loop2:
			readFile cx, tmp, 1, ax

			cmp ax, 0			;если файл закончился
			je _readWord_eof

			cmp tmp, ' '
			je _readWord_exit2

			cmp tmp, 10
			je _readWord_exit2

			mov bl, tmp
			mov [di], bl
			inc di
		jmp _readWord_loop2
		_readWord_exit2:
		mov [bp+6], 0

		jmp _readWord_brk
		_readWord_eof:	
			mov [bp+6], 1
		_readWord_brk:

		mov [di], '$'		;установка символа конца строки
		
		popa
		pop bp
		ret 2
	_readWord endp

	main proc				
		
		push ds					;помещение ds в стек stk, в ds находится смещение, по которому находится префикс сегмента кода
		sub ax,ax				;ax = ax-ax => ax=0;
		push ax					;помещенние ax в стек stk

		mov ax, data				;ax = data
		mov ds, ax				;ds = ax
		mov es, ax
		;-------user code--------
		openFile filename, f
		
		sub bx, bx		;счетчик слов
		loop1:
			readWord f, buf, ax	;чтение слова

			lea si, sample		;сравнение строк
			lea di, buf
			mov cx, 3
			repe cmpsb
			cmp cx, 0
			jne _dont_inc
				inc bx
			_dont_inc:

			strOut buf
			newline

			cmp ax, 1
			je _eof
		jmp loop1
		_eof:

		unsignWordOut bx
		newline

		closeFile f
		;------------------------
		mov ax, 4c00h
		int 21h

	main endp
code ends

end main		;точка входа в программу
