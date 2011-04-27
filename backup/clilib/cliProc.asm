.286
public _setCur, _getCur, _attrCharOut, _setAttrBits, _clAttrBits, _getChar
aux_seg segment byte
	assume cs:aux_seg
	;-----data--------
	attr db 00000111b	;аттрибут вывода символа (по умолчанию белый шрифт на чером фоне)
	
	;-----code--------
	;если через стек передается байт, то используется младшая часть слова

	;установка курсора	
	_setCur proc far
		;usage:
		;push <col:line>
		;call _setCur
		;
		;BP|IP|CS|col:line|...
		push bp
		mov bp, sp
		pusha	
		
		mov ah, 02
		mov bh, 00
		mov dx, [bp+6]
		int 10h
			
		popa
		pop bp
		ret 2
	_setCur endp

	;получение координат курсора
	_getCur proc far
		;usage:
		;push <smth>
		;call _getCur
		;pop <col:line>
		;
		;BP|IP|CS|col:line|...
		push bp
		mov bp, sp
		pusha

		mov ah, 03
		mov bh, 00
		int 10h
		mov [bp+6], dx
		
		popa
		pop bp
		ret
	_getCur endp

	;вывод символа с аттрибутами
	_attrCharOut proc far
		;usage:
		;push <ch>
		;call _outAttrChar
		;
		;BP|IP|CS|ch|...
		push bp
		mov bp, sp
		pusha

		mov dx, [bp+6]

		mov ah, 09	
		mov al, dl
		mov bh, 0
		mov bl, attr
		mov cx, 1
		int 10h

		popa
		pop bp
		ret 2
	_attrCharOut endp

	;установка битов аттрибута
	_setAttrBits proc far
		;usage:
		;push <byte>
		;call _setAttrBits
		;
		;BP|IP|CS|byte|...
		push bp
		mov bp, sp
		pusha

		mov dx, [bp+6]
		or attr, dl

		popa
		pop bp
		ret 2
	_setAttrBits endp

	;сброс битов аттрибута
	_clAttrBits proc far
		;usage:
		;push <byte>
		;call _clAttrBits
		;
		;BP|IP|CS|byte|...
		push bp
		mov bp, sp
		pusha

		mov dx, [bp+6]
		and attr, dl

		popa
		pop bp
		ret 2
	_clAttrBits endp

	;получение символа под курсором и его аттрибута 
	_getChar proc far
		;usage:
		;push <smth>
		;call _getChar
		;pop <char:attr>
		;
		;BP|IP|CS|char:attr|..
		push bp
		mov bp, sp
		pusha

		mov ah, 08
		mov bh, 00
		int 10h

		mov [bp+6], ax

		popa
		pop bp
		ret
	_getChar endp
aux_seg ends
end
