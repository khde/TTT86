bits 64

; I don't care about the System V x86-64 Bit ABI calling conventions

%define P1 'X'
%define P2 'O'

%define POS1 0
%define POS2 2
%define POS3 4
%define POS4 12
%define POS5 14
%define POS6 16
%define POS7 24
%define POS8 26
%define POS9 28

%define NL 0xa

%define SYSCALL_READ 0x0
%define SYSCALL_WRITE 0x1

%macro clearscreen 0
    mov rax, SYSCALL_WRITE
    mov rdi, 0x1
    lea rsi, [s_clearscreen]
    mov rdx, s_clearscreen_len
    syscall
%endmacro


section .data
    field_mask db " | | ", NL, "-----", NL, " | | ", NL, "-----", NL, " | | ", NL, 0x0
    field_mask_pos db POS1, POS2, POS3, POS4, POS5, POS6, POS7, POS8, POS9
    field_mask_len equ $ - field_mask

    p1v db "Victory for X", NL, 0x0
    p1v_len equ $ - p1v

    p2v db "Victory for O", NL, 0x0
    p2v_len equ $ - p2v

    player_turn db 0
    player1t db "X: ", 0x0
    player2t db "O: ", 0x0

    s_clearscreen db 27,"[H",27,"[2J"
    s_clearscreen_len equ $ - s_clearscreen


section .bss
    buffer_input resb 2


section .text
global _start

_start:
    xor r15, r15

.game_loop:
    clearscreen
    call draw_field
    call handle_input
    call check_winner

    cmp r15, 0x0
    je .game_loop

.tmp:
    mov rax, 60
    mov rdi, 0
    syscall


handle_input:
    push rbp
    mov rbp, rsp

    cmp [player_turn], byte 0x0
    jne .p2t
    mov rsi, player1t
    jmp .tdone
.p2t:
    mov rsi, player2t
.tdone:
    mov rax, SYSCALL_WRITE
    mov rdi, 0x1
    mov rdx, 0x3
    syscall
.retry:
    mov rax, SYSCALL_READ
    mov rdi, 0x0
    lea rsi, [buffer_input]
    mov rdx, 2
    syscall

    xor rdi, rdi
    mov dil, [buffer_input]
    sub rdi, 0x31

    cmp rdi, 0x0
    jl .retry

    cmp rdi, 0x9
    jg .retry

    cmp [player_turn], byte 0x0
    jne  .p2
    mov rsi, P1
    jmp .done
.p2:
    mov rsi, P2
.done:
    call put_mark

    leave
    ret


;rdi: Position 0-8, rsi: Player P1 or P2
put_mark:
    push rbp
    mov rbp, rsp

    mov rax, field_mask
    add rdi, field_mask_pos

    xor rbx, rbx
    mov bl, [rdi]
    add rax, rbx

    cmp [rax], byte 0x20  ; 32
    jne .done

    cmp rsi, P1
    jne .p2
    mov [rax], byte P1
    mov [player_turn], byte 0x1
    jmp .done 
.p2:
    mov [rax], byte P2
    mov [player_turn], byte 0x0
.done:
    leave
    ret


check_winner:
    push rbp
    mov rbp, rsp

    call draw_field

    mov rdi, P1
    call checking_winner
    cmp rax, 0x1
    jne .p2

    clearscreen
    call draw_field
    mov r15, 0x1

    mov rax, 0x1
    mov rdi, 0x1
    lea rsi, [p1v]
    mov rdx, p1v_len
    syscall

    mov r15, 0x1
    jmp .exit

.p2
    mov rdi, P2
    call checking_winner
    cmp rax, 0x1
    jne .exit

    clearscreen
    call draw_field
    mov r15, 0x1

    mov rax, 0x1
    mov rdi, 0x1
    lea rsi, [p2v]
    mov rdx, p2v_len
    syscall

.exit
    leave
    ret


; rdi: player char
checking_winner:
    push rbp
    mov rbp, rsp

    mov rax, field_mask
    cmp [eax], dil
    jne .l2

    mov rax, field_mask
    add rax, POS2
    cmp [rax], dil
    jne .l2

    mov rax, field_mask
    add rax, POS3
    cmp [rax], dil
    jne .l2

    jmp .win

.l2:
    mov rax, field_mask
    add rax, POS4
    cmp [rax], dil
    jne .l3

    mov rax, field_mask
    add rax, POS5
    cmp [rax], dil
    jne .l3

    mov rax, field_mask
    add rax, POS6
    cmp [rax], dil
    jne .l3

    jmp .win

.l3:
    mov rax, field_mask
    add rax, POS7
    cmp [rax], dil
    jne .l4

    mov rax, field_mask
    add rax, POS8
    cmp [rax], dil
    jne .l4

    mov rax, field_mask
    add rax, POS9
    cmp [rax], dil
    jne .l4

    jmp .win

.l4:
    mov rax, field_mask
    add rax, POS1
    cmp [rax], dil
    jne .l5

    mov rax, field_mask
    add rax, POS4
    cmp [rax], dil
    jne .l5

    mov rax, field_mask
    add rax, POS7
    cmp [rax], dil
    jne .l5

    jmp .win

.l5:
    mov rax, field_mask
    add rax, POS2
    cmp [rax], dil
    jne .l6

    mov rax, field_mask
    add rax, POS5
    cmp [rax], dil
    jne .l6

    mov rax, field_mask
    add rax, POS8
    cmp [rax], dil
    jne .l6

    jmp .win

.l6:
    mov rax, field_mask
    add rax, POS3
    cmp [rax], dil
    jne .l7

    mov rax, field_mask
    add rax, POS6
    cmp [rax], dil
    jne .l7

    mov rax, field_mask
    add rax, POS9
    cmp [rax], dil
    jne .l7

    jmp .win

.l7:
    mov rax, field_mask
    add rax, POS1
    cmp [rax], dil
    jne .l8

    mov rax, field_mask
    add rax, POS5
    cmp [rax], dil
    jne .l8

    mov rax, field_mask
    add rax, POS9
    cmp [rax], dil
    jne .l8

    jmp .win

.l8:
    mov rax, field_mask
    add rax, POS3
    cmp [rax], dil
    jne .done

    mov rax, field_mask
    add rax, POS5
    cmp [rax], dil
    jne .done

    mov rax, field_mask
    add rax, POS7
    cmp [rax], dil
    jne .done

.win:
    mov rax, 0x1
    jmp .exit

.done:
    mov rax, 0x0

.exit:
    leave
    ret


draw_field:
    push rbp
    mov rbp, rsp

    mov rax, SYSCALL_WRITE
    mov rdi, 0x1
    lea rsi, [field_mask]
    mov rdx, field_mask_len
    syscall

    leave
    ret

