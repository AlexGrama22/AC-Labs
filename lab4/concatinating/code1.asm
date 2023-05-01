NULL EQU 0
STD_OUTPUT_HANDLE EQU -11

extern _GetStdHandle@4
extern _WriteFile@20
extern _ExitProcess@4
extern _MessageBoxA@16

global Start

section .data
    Caption db "Concatenated Strings", 0
    string_array:
        string1 db "Nu ", 0
        string2 db " are ", 0
        string3 db "sens", 0
    string_pointers dd string1, string2, string3
    array_size equ ($ - string_pointers) / 4

section .bss
    StandardHandle resd 1
    Written resd 1
    result_str resb 256

section .text
Start:
    ; Get the standard output handle
    push STD_OUTPUT_HANDLE
    call _GetStdHandle@4
    mov dword [StandardHandle], EAX

    ; Concatenate the strings
    xor ecx, ecx
    lea edi, [result_str]
    concat_loop:
        mov eax, [string_pointers + ecx * 4]
        mov esi, eax
        cld
    copy_loop:
        lodsb
        stosb
        test al, al
        jnz copy_loop
        dec edi ; Remove extra null-termination
        inc ecx
        cmp ecx, array_size
        jne concat_loop

    ; Null-terminate the result string
    mov byte [edi], 0

    ; Call the ShowMessageBox function
    push result_str
    call ShowMessageBox

    ; Exit the program
    push NULL
    call _ExitProcess@4

; New function to show a message box
ShowMessageBox:
    push EBP
    mov EBP, ESP
    ; Show the message box with the concatenated string
    push 0 ; MB_OK
    push Caption ; lpCaption
    push dword [EBP+8] ; lpText
    push NULL ; hWnd
    call _MessageBoxA@16
    pop EBP
    ret
