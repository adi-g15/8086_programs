title switch
page 60,132 
.model small 
.stack 64
.data
    ; Expecting input switch on stack top, ie. some caller added it

    CASE_1  equ 1Ah
    CASE_2  equ 3Bh
    CASE_3  equ 04h

    CASE_1_STR db "Matched case_1$"
    CASE_2_STR db "Matched case_2$"
    CASE_3_STR db "Matched case_3$"
    CASE_DEF_STR db "No case matched, executing default block$"

.code
main proc far 
mov ax,@DATA 
mov ds,ax 

mov ax, 0bh
push ax
    
    pop bx

    mov ax, bx
    xor ax, CASE_1      ; ax = ax^bx = SWITCH_INPUT ^ CASE_1
    jz  case1       ; if ax^bx = 0 => SWITCH_INPUT == CASE_1

    xor ax, CASE_2
    xor ax, CASE_1  ; ax = (switch^case1)^(case1^case2) = 
                    ; (switch^case2)^0 = switch ^ case2
    jz case2

    xor ax, CASE_3
    xor ax, CASE_2   ; => ax = SWITCH_INPUT ^ CASE_3 ^ 0
    jz case3                ; if ax == 0, then CASE_3 matched SWITCH_INPUT
    jmp default             ; Unconditional jump to the default case

case1:
    lea dx, CASE_1_STR
    jmp break
case2:
    lea dx, CASE_2_STR
    jmp break
case3:
    lea dx, CASE_3_STR
    jmp break
default:
    lea dx, CASE_DEF_STR
    jmp break

break:
    mov ah, 09h
    int 21h
; DOS 21h Exit function code
exit:
    mov ah,4ch
    int 21h 
    main endp 
    end main 
