title CRC
page 60,132
.model small
.stack 100h
.data
    Message DW 1A76h ; exactly (16-N) bits -> 1 1010 0111 0110
    N        equ 03h
    GEN_POLY equ 0Bh  ; (N+1 bits) -> 1011

    ; Storage required:
    ; MESSAGE (will work as result too) -> 16-bit
    ; Generator polynomial N bits -> (but will be stored in 16-bit to be xorred) -> 16-bit

.code
main proc far
    mov ax,@DATA
    mov ds,ax

    ; Stores the message/result in AX
    mov ax, Message ; ax = MESSAGE

store_gen_poly_in_16_bit:
    mov bx, GEN_POLY    ; Store gen poly in bx

    ; Loop while the 1st non-0 bit of the poly becomes the MSB
    ; while bx & 0x8000 == 0
    ;   shl bx, 1
    jmp loop1
shift1:
        shl bx, 1       ; Shift left 1 bit
loop1:
        test bx, 8000h  ; ANDs bx and 0x8000 (ie. 1000 0000 0000 0000) to check if
                        ; MSB is 1, if not, zero flag is set
        jz shift1       ; If bx & 0x8000 == 0, jump to shift1
    
    ; Now shifting message bits to have N zeroes at end
    mov cx, N
shift2:
        shl ax, 1   ; append n zeroes, by shifting left N bits
        loop shift2

        ; Now, ax stores the message(&result), bx stores generator

    ; Algo:
    ; Keep shifting generator xor with message
    ; until the message part of result is 0
    ; last n bit of result is remainder

    ; while ax<15(MSB):3(N)> != 0
    ;   xor ax, bx
    ;   shr bx, 1
loop2:
        xor ax, bx

        ; Now updating bx, 'for next iteration'
        mov cx, 0
        ; available registers: cx, dx
        ; add condition here to shift bx, so that first 1 of ax and bx matches
        ; Finding leading zeroes in result
        mov dx, ax
        ; add cx, number_of_leading_zeroes_in_dx
        call num_leading_zeroes_in_dx   ; answer stored in dx itself
        add cx, dx

        ; Now, finding leading zeroes in bx
        mov dx, bx
        ; sub cx, number_of_leading_zeroes_in_dx
        call num_leading_zeroes_in_dx   ; answer is stored in dx
        sub cx, dx
        ; 0001011110110000
        ; 0001101000000000
shift_bx:
        shr bx, 1
        loop shift_bx
       
        ; Shifting right N bits, (to ignore last N bit, to get ax<15:N>)
        mov cx, N
        mov dx, ax  ; Temporarily copying ax into dx
shift3:
        shr dx, 1   ; Shift 1 bit right
        loop shift3

        cmp dx, 0   ; Set zero flag for next jump
        jnz loop2  ; loop to xor again

exit:
	mov ah,4ch	; function code for “Exit”
	int 21h 	; DOS syscall interrupt
main endp 		; End procedure ‘main’

num_leading_zeroes_in_dx proc near
    cmp dx, 0
    jz all_zeroes   ; Handling the corner case, when no 1 in 16-bit then answer
                    ; 'would have been' > 16
    push cx         ; push cx onto stack, to save it's value in memory
    mov cx, 0       ; cx = 0
    jmp loop_num
    ; while dx & 0x8000 == 0
    ;   ++cx
shift_num:
    shl dx, 1       ; Shift left 1 bit
    inc cx          ; ++cx, increase count
loop_num:
    test dx, 8000h  ; AND dx and 1000 0000 0000 0000, to test if MSB is 1 or not
    jz shift_num    ; true when MSB was NOT 1
    mov dx, cx      ; since caller expects output in dx, copy cx's value to dx
    pop cx          ; after use of cx done, we restore it's previous value
    ret             ; return
all_zeroes:
    mov dx, 16      ; dx = 16 = number_of_bits_in_dx
    pop cx          ; after use of cx done, we restore it's previous value
    ret
num_leading_zeroes_in_dx endp
end main

