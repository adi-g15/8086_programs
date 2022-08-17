title Virhanka
page 60,132 
.model small 
.stack 100h
.data
    N dw 5h
.code
main proc far 
mov ax,@DATA 
mov ds,ax 

    mov cx,N
    cmp cx, 0
    jl  exit    ; Exit for invalid input (ie. any negative cx)
    mov ax,1
    jmp iter
multiply:
    mul cx
    dec cx
iter:
    cmp cx, 0
    jnz multiply     ; Repeat till cx becomes zero
    
    ; ax has the result
exit:
    mov ah,4ch
    int 21h 
    main endp 
    end main 
