NULL EQU 0
STD_OUTPUT_HANDLE EQU -11
extern _GetStdHandle@4
extern _WriteFile@20
extern _ExitProcess@4
extern _MessageBoxA@16

global Start

section .data
    Caption db "Sum", 0
    Message db "The result is:", 0
    MessageLength EQU $-Message
    num1 dd 1
    num2 dd 2
    result dd 0

section .bss
    StandardHandle resd 1
    Written resd 1
    result_str resb 11

section .textstring
    Start:
    push STD_OUTPUT_HANDLE
    call _GetStdHandle@4
    mov dword [StandardHandle], EAX

    mov EAX, [num1]
    add EAX, [num2]
    mov [result], EAX

    mov EAX, [result]
    call DecimalToString

    ; Call the ShowMessageBox function
    push result_str
    call ShowMessageBox

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

; New function to show a message box
ShowMessageBox:
    push EBP
    mov EBP, ESP
    ; Show the message box with the result
    push 0 ; MB_OK
    push Caption ; lpCaption
    push dword [EBP+8] ; lpText
    push NULL ; hWnd
    call _MessageBoxA@16
    pop EBP
    ret
