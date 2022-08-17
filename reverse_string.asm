title Reverse String
page 60,132 
.model small
.stack 100h
.data
    src   db 'Namaste'
    dest  db  7 dup(?)
    count dw  7

.code
main proc far   ; declare the 'main' procedure
mov ax,@DATA    ; temporary step to store value of @data in data segment register
mov ds,ax       ; ds = ax = @DATA

begin:  mov es,ax       ; storing address in ax, in extra segment register
        mov cx,count    ; cx = count
        mov si,0        ; si = 0 (used for source indexing)
        mov di, count   ; di = count
        dec di          ; --di = count - 1

; could use "movsb", and "stosb" instruction too
again:  mov al, src[si]  ; store byte at src[si] in al
        mov dest[di], al ; store byte in al, at dest[di]
        inc si           ; ++si
        dec di           ; --di
        loop again       ; jmp to 'again' label, till cx != 0

; DOS interrupt 21h, exit function code 4ch part
exit:
    mov ah,4ch
    int 21h 
    main endp 
    end main 
