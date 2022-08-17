title Using Interrupt (b)
page 60,132
.model small
.stack 100h
.data
    LEN      equ 50h
    PADDING  equ 8h
    START_X  equ 24h
    START_Y  equ 15h
.code
    main proc far
    mov ax,@DATA
    mov ds,ax

setup_graphics:
    mov ah, 00h ; set config to video mode
    mov al, 13h ; chosing the video mode
    int 10h     ; BIOS interrupt

    mov ah,0Bh  ; set config to
    mov bh, 0   ; background color
    mov bl, 0   ; chosing black as background
    int 10h

    mov bx,START_X    ; x_coord
    mov dx,START_Y    ; y_coord
    mov cx,LEN        ; cx = LEN
    inc cx      ; ++cx
    jmp draw_line

draw_horizontal:
    push cx
    push bx

    mov cx,PADDING
pixel:
    push cx

    inc bx
    mov cx,bx
    call draw_pixel

    pop cx
    dec cx
    jnz pixel

    pop bx
    pop cx
draw_line:
    inc bx  ; x_coord++
    inc dx  ; y_coord++

    dec cx
    jnz draw_horizontal

exit:
	mov ah,4ch	; function code for “Exit”
	int 21h 	; DOS syscall interrupt
main endp 		; End procedure ‘main’

draw_pixel proc near
    mov ah, 0Ch ; set config to drawing pixel
    mov al, 0Fh ; chosing white colour
    mov bh, 0   ; page number
    ; Expecting cx & dx to be set to coord, done in draw_horizontal
    int 10h

    ret
draw_pixel endp

end main

