title Parenthesis Matching
page 60,132 
.model small 
.stack 64
.data
    string DB "())())"  ; The string with open and close parenthesis
    N      equ 6h        ; String length

.code
main proc far 
mov ax,@DATA 
mov ds,ax 

mov cx, N      ; Initialise counter with length
mov si, 0       ; SI = 0
; while cx>0:
;  next
;  add

cmp cx,0    ; To set flags for the next jmp
jle exit    ; N <= 0, Exit rightaway for invalid input

mov ax, 0   ; ax = 0
loop1:
    mov bl, string[si]  ; Load a byte from string[si] into bl
    inc si              ; ++SI
    cmp bl,'('          ; Checking if the character is '('
    jne decrease        ; If not, then --ax
    inc ax              ; If it is '(', then ++ax
    jmp next            ; to skip the decrease step
decrease:
    dec ax              ; --ax
next:
    dec cx              ; --cx
    jnz loop1           ; if cx != 0, then go to loop1
; Could use 'loop' statement too

; If ax == 0, matched, else not matched
cmp ax, 0
jz exit
mov ax, 1   ; ax = 1, signifies parenthesis not matched

exit:
    mov ah,4ch
    int 21h 
    main endp 
    end main 

