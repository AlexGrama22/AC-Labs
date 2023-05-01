NULL EQU 0
STD_OUTPUT_HANDLE EQU -11

extern _GetStdHandle@4
extern _WriteFile@20
extern _ExitProcess@4
extern _MessageBoxA@16

global Start

section .data
    Caption db "String Lengths Sum", 0
    Message db "The sum of the string lengths is:", 0
    MessageLength EQU $-Message
    string_array:
        string1 db "Hello", 0
        string2 db "World", 0
        string3 db "Assembly", 0
    string_lengths dd string2 - string1, string3 - string2, $ - string3
    array_size equ ($ - string_lengths) / 4

section .bss
    StandardHandle resd 1
    Written resd 1
    result dd 0
    result_str resb 11

section .text
Start:
    ; Get the standard output handle
    push STD_OUTPUT_HANDLE
    call _GetStdHandle@4
    mov dword [StandardHandle], EAX

    ; Calculate the sum of the string lengths
    mov ecx, array_size
    xor eax, eax
    mov esi, string_lengths
    add_loop:
        add eax, [esi]
        add esi, 4
        loop add_loop
    mov [result], eax

    ; Convert the result to a string
    mov EAX, [result]
    call DecimalToString

    ; Call the ShowMessageBox function
    push result_str
    call ShowMessageBox

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
