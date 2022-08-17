title CGPA
page 60,132 
.model small 
.stack 64
.data
; stack contains: N, ('C', 4),('A',3),('A','+',1) (each 2 bytes)
    accumulated_grade_points DW 0   ; Stores total marks (will be divided by dx to obtain cg)
    total_credit             DW 0   ; Stores total credits

.code
main proc far 
mov ax,@DATA 
mov ds,ax 

; START input
mov ax,1
push ax
mov ax, '+'
push ax
mov ax, 'A'
push ax
mov ax, 3h
push ax
mov ax, 'A'
push ax
mov ax, 4
push ax
mov ax, 'C'
push ax
mov ax, 3h
push ax
; END input

pop cx  ; N will be 2 bytes, not like others

; while cx > 0
;   2 popped characters
;   add
cmp cx, 0
jle  exit   ; Invalid input N <= 0

iter:
    pop bx      ; pop grade
    jmp credit
reinput_cred:
    dec bx      ; --bx, so 'A' becomes 'A'-1 (so that it is 'farther')
    pop dx      ; MUST contain credits
    jmp continue
credit:
    pop dx      ; contains credits
    cmp dx, '+' ; If it was '+' instead of a number
    je  reinput_cred
continue:
    mov ax, total_credit
    add ax, dx  ; add current course's credit

    push bx     ; store value of bx on stack
    lea bx, total_credit    ; load effective address (ie. to get address of
                            ; total_credit in bx)
    mov WORD PTR [bx], ax ; store updated total_credit
    pop bx      ; restore value of bx

    sub bx,'J'  ; bx = bx - 'J'; 'A'-'J' becomes -9
    neg bx      ; negate bx, ie. -9 -> 9

        mov ax, 1
        push dx ; Store dx value, as mul may use DX for overflow if any
        mul bx  ; 1*grade_point
        pop dx  ; Restore dx value
        mul dx  ; 1*grade_point*credits
        ; CRITICAL WARNING: I am ignoring DX, that may also have value, but not
        ; working with larger than 1 byte, so if it occurs it's a logical error
        mov dx,ax   ; save the result of multiplication in dx

    mov ax, accumulated_grade_points
    lea bx, accumulated_grade_points    ; load effective address, get address
    add ax, dx      ; add current sum to ax
    mov WORD PTR [bx], ax

    dec cx
    jnz iter

mov ax, accumulated_grade_points    ; ax contains cummulative grade point ('A+' (ie. 10) + 'A'(ie. 9) +'B'(ie. 8))
mov bx, total_credit                ; dx contains total credits
mov dx, 0                           ; dx:ax is divided by bx in next step
div bx                              ; ax = ax/dx is cgpa (whole number in ax,
                                    ; remainder in dx)

; DOS 21h Exit function code
exit:
    mov ah,4ch
    int 21h 
    main endp 
    end main 

