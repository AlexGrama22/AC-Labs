NULL EQU 0
MB_DEFBUTTON EQU 100h
IDNO EQU 7
MB_YESNO EQU 4

extern _MessageBoxA@16
extern _ExitProcess@4

global Start

section .data

MessageBoxMessage db "Can I close this window?", 0
MessageBoxTitle db "Chestionar", 0

section .text

Start:

push MB_YESNO | MB_DEFBUTTON
push MessageBoxTitle
push MessageBoxMessage
push NULL
call _MessageBoxA@16

cmp EAX, IDNO
je Start

push NULL
call _ExitProcess@4
