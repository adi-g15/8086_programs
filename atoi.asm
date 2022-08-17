title atoi
page 60,132 
.model small 
.stack 64
.data
    NUMBER_STR  DB "15035"
    N           equ $ - NUMBER_STR
.code
main proc far 
mov ax,@DATA 
mov ds,ax 

    mov cx, N
    mov si, 0
    mov ax, 0
    
    ; while N != 0:
    ;   ax *= 10
    ;   ax += bl-'0'
iter:
    mov bx, 0Ah ; temporarily storing 10 in dx
    mov dx, 0   ; clear dx, since that is used in mul of words
    mul bx      ; ax = ax * 0x0A = ax * 10
    mov bh, 0   ; clear higher byte of bx
    mov bl, NUMBER_STR[si]
char_to_num:
    add ax, bl  ; ax += character (bl)
    sub ax, '0' ; ax -= '0' = character - '0'; ie. '0' will become 0, '9'
                ; becomes 9

    inc si      ; ++si
    dec cx      ; --cx
    jnz iter    ; iterate till cx != 0

; Here ax will have the number

; DOS 21h Exit function code
exit:
    mov ah,4ch
    int 21h 
    main endp 
    end main 

