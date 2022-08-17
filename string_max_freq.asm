title Max frequency
page 60,132 
.model small 
.stack 100h
.data
    STRING db "microprocessor"  ; ALL LOWERCASE
    LEN equ $ - STRING          ; '$' evaluates to current address, so $-STRING
                                ; is length of string, ie. 14, this feature is
                                ; by assembler so didn't use in other
    MAP    db 26 DUP(0)

; MAP is basically a 26 length array, where 'a' maps to index 0, and 'z' to 25
; Each index stores a count of how many times the number occured

.code
main proc far 
mov ax,@DATA 
mov ds,ax 

    cld         ; set direction flag = 0
    mov si, OFFSET STRING   ; init SI
    mov cx, LEN
count:
    lodsb       ; load 1 byte from string to AL
    sub al, 'a' ; Now al will have 0 for 'a', 1 for 'b', so on...

    mov ah, 0   ; ax = 0
    mov di,ax   ; di = ax, setting a destination index
    mov bh, MAP[di] ; get previous count of occurences of the current letter
    inc bh          ; ++bh, increment number of current letter
    mov MAP[di], bh ; Updating the count, stored at MAP indexed by di
    loop count      ; loop until cx != 0

; while(cx!=0):
;   if MAP[si] > MAP[di]:
;       dx = MAP[si]
;   si++
    mov si, 0   ; si = 0
    mov di, 0   ; di = 0; di will store max index
    mov cx, 26  ; to iterate over 26 character map
find_max:
    mov al, MAP[si]
    cmp al, MAP[di]
    jl  continue       ; if lesser, then continue
update_max:
    mov di, si         ; else update index of max element, ie. di
continue:
    inc si             ; ++si
    loop find_max      ; loop until cx != 0

; di has index of most frequent letter
mov ax,di               ; ax = di
add ax,'a'              ; ax = ax + 'a' = 'a' + di, ie. we get the most frequent character in ax

; ax has most frequent letter

; DOS Exit function
exit:
    mov ah,4ch
    int 21h 
    main endp 
    end main 

