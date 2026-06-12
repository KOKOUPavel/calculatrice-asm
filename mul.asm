section .text
    global _start

_start:
    mov eax, 7
    mov ebx, 6
    mul ebx

    mov ebx, eax
    mov eax, 1
    int 0x80
