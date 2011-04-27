.286
public  _plot, _line, _circle, _fillscr

aux_seg segment byte
	assume cs:aux_seg
	
	;заполнение экрана цветом color
	_fillscr proc far
		;usage:
		;push color
		;call _fullscr
		;
		;BP|CS|IP|color|...
		push bp
		mov bp, sp
		pusha

		mov dl, [bp+6]
		mov dh, [bp+6]
		mov cx, 320*100
		sub di, di
		_fillscr_loop1:
			mov word ptr es:[di], dx
			add di, 2
		loop _fillscr_loop1

		popa
		pop bp
		ret 2
	_fillscr endp

	;рисование пикселя цвета color в (x,y)
	_plot proc far
		;usage:
		;push x
		;push y
		;push color
		;call _plot
		;
		;BP|CS|IP|color|y|x|...
		push bp
		mov bp, sp
		pusha
		
		mov cx, [bp+10]	;x
		mov ax, [bp+8]	;y

		mov bx, 320
		mul bx		;ax = y*320
		
		mov di, cx	;di = x+y*320
		add di, ax

		mov dl, [bp+6]	;color
		mov byte ptr es:[di], dl

		popa
		pop bp
		ret 6
	_plot endp

	;рисование линии от (x0,y0) до (x1,y1)
	_line proc far
		;usage:
		;push color
		;push x0
		;push y0
		;push x1
		;push y1
		;call _line
		;
		;0  2  4  6  8  10 12 14
		;BP|CS|IP|y1|x1|y0|x0|color|...
		push bp
		mov bp, sp
		pusha

	;данные
		jmp _skip_data_line
			deltax dw ?
			deltay dw ?
			error dw 0
			deltaerr dw ?
			x dw ?
			y dw ?
		_skip_data_line:

	;код
		;если x0>x1 && y0>y1 то поменять местами x0,x1 и y0,y1
		mov ax, [bp+12]		;cmp x0, x1
		cmp ax, [bp+8]
		jle _dont_swap

		mov ax, [bp+10]		;cmp y0, y1
		cmp ax, [bp+6]
		jle _dont_swap
			;swap(x0,x1)
			push [bp+12]
			push [bp+8]
			pop [bp+12]
			pop [bp+8]

			;swap(x0,x1)
			push [bp+10]
			push [bp+6]
			pop [bp+10]
			pop [bp+6]
		_dont_swap:

		;вычисление значения прибавляемое к x
		mov si, 1
		mov ax, [bp+12]		;cmp x0, x1
		cmp ax, [bp+8]
		jle _dont_neg_si
			mov si, -1
		_dont_neg_si:

		;вычисление значения прибавляемое к y
		mov di, 1
		mov ax, [bp+10]		;cmp y0, y1
		cmp ax, [bp+6]
		jle _dont_neg_di
			mov di, -1
		_dont_neg_di:


		;deltax = abs(x0-x1)
		mov ax, [bp+12]
		mov deltax, ax
		mov ax, [bp+8]
		sub deltax, ax
		cmp deltax, 0
		jge _dont_neg1
			neg deltax
		_dont_neg1:

		;deltay = abs(y0-y1)
		mov ax, [bp+10]
		mov deltay, ax
		mov ax, [bp+6]
		sub deltay, ax
		cmp deltay, 0
		jge _dont_neg2
			neg deltay
		_dont_neg2:

		;определение по какой координате бежать
		mov ax, deltax
		cmp ax, deltay
		jl _change_y
		;---cлучай 1-----
		;cx = abs(x1-x0)
		mov cx, deltax

		;deltaerr = deltay
		push deltay
		pop deltaerr

		;y=y0
		push [bp+10]
		pop y
		
	
		;x = x0
		push [bp+12]
		pop x
		_line_loop1:
			;plot(x,y,255)
			push x
			push y
			push [bp+14]	;цвет
			call _plot

			;error += deltaerr
			mov ax, deltaerr
			add error, ax

			;if(2*error>=deltax)
			mov ax, error
			shl ax, 1	;ax= 2*error
			cmp ax, deltax
			jl _dont_inc1
				add y, di

				mov ax, deltax
				sub error, ax
			_dont_inc1:

			add x, si
		loop _line_loop1
		jmp _exit

		_change_y:
		;----случай 2----
		;cx = abs(y1-y0)
		mov cx, deltay
		
		;deltaerr = deltax
		push deltax
		pop deltaerr

		;x=x0
		push [bp+12]
		pop x
		
		;y = y0
		push [bp+10]
		pop y
		_line_loop2:
			;plot(x,y,255)
			push x
			push y
			push [bp+14]	;цвет
			call _plot

			;error += deltaerr
			mov ax, deltaerr
			add error, ax

			;if(2*error>=deltay)
			mov ax, error
			shl ax, 1	;ax= 2*error
			cmp ax, deltay
			jl _dont_inc2
				add x, si

				mov ax, deltay
				sub error, ax
			_dont_inc2:

			add y, di
		loop _line_loop2
	
		_exit:
		popa
		pop bp
		ret 10
	_line endp

	_circle proc far
		;usage:
		;push x1
		;push y1
		;push R
		;push color
		;   2  4  6     8 10 12
		;BP|CS|IP|color|R|y1|x1|...
		push bp
		mov bp, sp
		pusha
		
		;si - x
		;di - y
		;dx - delta
		;cx - error
		
		sub si,si	;x=0
		mov di, [bp+8]	;y=R
		
		;delta = 2-2*R
		mov dx, 2
		mov ax, [bp+8]
		shl ax, 2
		sub dx, ax

		;error = 0;
		sub cx, cx

		_circle_loop1:
			cmp di, 0
			jge _continue
				jmp _exit1
			_continue:

			;plot(x1+x, y1+y)
			mov ax, [bp+12]
			add ax, si
			push ax
			mov ax, [bp+10]
			add ax, di
			push ax
			push [bp+6]
			call _plot

			;plot(x1+x, y1-y)
			mov ax, [bp+12]
			add ax, si
			push ax
			mov ax, [bp+10]
			sub ax, di
			push ax
			push [bp+6]
			call _plot

			;plot(x1-x, y1+y)
			mov ax, [bp+12]
			sub ax, si
			push ax
			mov ax, [bp+10]
			add ax, di
			push ax
			push [bp+6]
			call _plot

			;plot(x1-x, y1-y)
			mov ax, [bp+12]
			sub ax, si
			push ax
			mov ax, [bp+10]
			sub ax, di
			push ax
			push [bp+6]
			call _plot

			;error = 2*(delta+y)-1
			mov cx, dx
			add cx, di
			shl cx, 1
			dec cx

			;if(delta<0 && error<=0) 
			cmp dx, 0
			jge _skip1
			cmp cx, 0
			jg _skip1
				;delta += 2*(++x)+1
				inc si		;++x

				mov ax, si
				shl ax, 1
				add dx, ax
				inc dx
				jmp _circle_loop1	;continue
			_skip1:

			;error = 2*(delta-x)-1
			mov cx, dx
			sub cx, si
			shl cx, 1
			dec cx

			;if(delta>0 && error>0) 
			cmp dx, 0
			jle _skip2
			cmp cx, 0
			jle _skip2
				dec di		;--y
				;delta+=1-2*y
				mov ax, di
				shl ax, 1
				inc dx
				sub dx, ax
				jmp _circle_loop1	;continue
			_skip2:

			inc si	;++x

			;delta += 2*(x-y)
			mov ax, si
			sub ax, di
			shl ax, 1
			add dx, ax

			dec di	;--y
		jmp _circle_loop1
		_exit1:

		popa
		pop bp
		ret 8
	_circle endp

aux_seg ends
end
