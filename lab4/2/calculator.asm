NULL EQU 0
STD_OUTPUT_HANDLE EQU -11
extern _GetStdHandle@4
extern _WriteFile@20
extern _ExitProcess@4

global Start

section .data
    Message db "The result is:", 0
    MessageLength EQU $-Message
    num1 dd 10
    num2 dd 20
    result dd 0

section .bss
    StandardHandle resd 1
    Written resd 1
    result_str resb 11

section .text
    Start:
    ; Get the standard output handle
    push STD_OUTPUT_HANDLE
    call _GetStdHandle@4
    mov dword [StandardHandle], EAX

    ; Add the two numbers and store in result
    mov EAX, [num1]
    add EAX, [num2]
    mov [result], EAX

    ; Convert the result to a string
    mov EAX, [result]
    call DecimalToString

    ; Write the message and the result to standard output
    push NULL
    push Written
    push MessageLength
    push Message
    push dword [StandardHandle]
    call _WriteFile@20

    push NULL
    push Written
    push 11
    push result_str
    push dword [StandardHandle]
    call _WriteFile@20

    ; Exit the program
    push NULL
    call _ExitProcess@4

DecimalToString:
    push EBP
    mov EBP, ESP
    sub ESP, 8
    mov dword [EBP-4], 0
    mov dword [EBP-8], 10
.Loop:
    xor EDX, EDX
    div dword [EBP-8]
    add DL, '0'
    mov byte [result_str+eax], DL
    inc dword [EBP-4]
    test EAX, EAX
    jnz .Loop
    mov EAX, dword [EBP-4]
    add ESP, 8
    pop EBP
    ret
