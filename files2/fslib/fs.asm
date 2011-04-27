.286
;Работа с файлами
extrn _createFile:far, _openFile:far, _closeFile:far, _readFile:far, _writeFile:far, _setPos:far, _getError:far, _readLine:far

;------Constants-------
START equ 00h
CUR equ 01h
END equ 02h
;----------------------

createFile macro fname, handler
	push dx

	lea dx, fname
	push dx
	call _createFile
	pop handler

	pop dx
endm

openFile macro fname, handler
	push dx
	
	lea dx, fname
	push dx
	call _openFile
	pop handler

	pop dx
endm

closeFile macro handler
	push handler	
	call _closeFile
endm

readFile macro handler, buf, size, read
	push dx

	push handler
	lea dx, buf
	push dx
	push size
	call _readFile
	pop read

	pop dx
endm

writeFile macro handler, buf, size
	push dx

	push handler
	lea dx, buf
	push dx
	push size
	call _writeFile

	pop dx
endm

setPos macro handler, mode, offset
	push handler
	push mode
	push offset
	call _setPos
endm

getError macro error
	push dx

	push dx
	call _getError
	pop error

	pop dx
endm

;чтение слова из текстового файла (размер буффера не учитывается)
readLine macro handler, buf, read
	push dx

	push handler
	lea dx, buf
	push buf
	call _readLine
	pop read

	pop dx
endm
