title Using Interrupt (a)
page 60,132
.model small
.stack 100h
.data
    string DB "VirHAnKa$"
    N      equ 8h
.code
    main proc far
    mov ax,@DATA
    mov ds,ax

    mov cx,N
    cmp cx, 0	; compares value in cx with 0, and sets flags
	jl exit 	; Exit for invalid input (ie. for N < 0)

    mov si, 0
    jmp iter
to_upper:
    sub al, 20h         ; al -= 20h, because 'a'- 32 = 'A', 32 = 0x20
    lea bx, string[si]  ; storing the updated character back at its place
    mov BYTE PTR [bx], al
iter:
    mov al, string[si]
    cmp al, 61h         ; 'a' = 97 = 0x61, assuming ONLY alphabets in string,
                        ; this WILL be lowercase letter if >= 97
    jge to_upper        ; lowercase letter, convert to upper
    inc si
    loop iter           ; loop until cx != 0
print:
    mov ah, 09h ; Function Code: WRITE STRING TO STANDARD OUTPUT
    lea dx, string
    int 21h
exit:
	mov ah,4ch	; function code for “Exit”
	int 21h 	; DOS syscall interrupt
main endp 		; End procedure ‘main’
end main

