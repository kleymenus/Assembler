.286
public _createFile, _openFile, _closeFile, _readFile, _writeFile, _setPos, _getError
aux_seg segment byte
	assume cs:aux_seg

	;----data----
	_error dw 0	;код ошибки

	;----code----

	;создание файла без замены
	_createFile proc far
		;usage:
		;push <fname>
		;call _createFile
		;pop <handler>
		;
		;BP|CS|IP|fname|...
		push bp
		mov bp, sp
		pusha

		mov cl, 0
		mov dx, [bp+6]
		mov ah, 5bh
		int 21h
		jnc _createFile_ok
			mov _error, ax
		_createFile_ok:
		mov _error, 0
		mov [bp+6], ax

		popa
		pop bp
		ret
	_createFile endp

	;открытие файла в режиме rw
	_openFile proc far
		;usage:
		;push <fname>
		;call _openFile
		;pop <handler>
		;
		;BP|CS|IP|fname|...
		push bp
		mov bp, sp
		pusha

		mov dx, [bp+6]
		mov al, 01000010b	;режим rw
		mov ah, 3dh
		int 21h
		jnc _openFile_ok
			mov _error, ax
		_openFile_ok:
		mov _error, 0
		mov [bp+6], ax

		popa
		pop bp
		ret
	_openFile endp

	;закрытие файла
	_closeFile proc far
		;usage:
		;push <handler>
		;call _closeFile
		;
		;BP|CS|IP|handler|...
		push bp
		mov bp, sp
		pusha

		mov ah, 3eh
		mov bx, [bp+6]
		int 21h
		jnc _closeFile_ok
			mov _error, ax
		_closeFile_ok:
		mov _error, 0

		popa
		pop bp
		ret 2
	_closeFile endp

	;чтение файла в буфер buf, размера size
	_readFile proc far
		;usage:
		;push <handler>
		;push <buf>
		;push <size>
		;call _readFile
		;pop <count of read bytes>
		;
		;BP|CS|IP|size|buf|handler|...
		push bp
		mov bp, sp
		pusha

		mov bx, [bp+10]
		mov dx, [bp+8]
		mov cx, [bp+6]
		mov ah, 3fh
		int 21h
		jnc _readFile_ok
			mov _error, ax
		_readFile_ok:
		mov _error, 0
		mov [bp+10], ax

		popa
		pop bp
		ret 4
	_readFile endp

	;запись в файл буфера buf размера size
	_writeFile proc far
		;usage:
		;push <handler>
		;push <buf>
		;push <size>
		;call _writeFile
		;
		;BP|CS|IP|size|buf|handler|...
		push bp
		mov bp, sp
		pusha

		mov bx, [bp+10]
		mov dx, [bp+8]
		mov cx, [bp+6]
		mov ah, 40h
		int 21h
		jnc _writeFile_ok
			mov _error, ax
		_writeFile_ok:
		mov _error, 0

		popa
		pop bp
		ret 6
	_writeFile endp

	;перемещение позиции курсора в файле	
	_setPos proc far
		;usage:
		;push <handler>
		;push <mode>
		;push <offset>
		;call _setPos 
		;
		;BP|CS|IP|offset|mode|handler|...
		push bp
		mov bp, sp
		pusha

		mov bx, [bp+10]
		sub dx, dx
		mov cx, [bp+6]
		mov al, [bp+8]
		mov ah, 42h
		int 21h

		popa
		pop bp
		ret 8
	_setPos endp

	;получение кода ошибки
	_getError proc far
		;usage:
		;push <smth>
		;call _getError
		;pop <error>
		;
		;BP|CS|IP|error|...
		push bp
		mov bp, sp
		pusha

		mov dx, _error
		mov [bp+6], dx

		popa
		pop bp
		ret
	_getError endp

aux_seg ends
end
