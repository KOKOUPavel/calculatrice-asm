section .text
    global _start

_start:
    mov eax, 10
    mov ebx, 4
    sub eax, ebx

    mov ebx, eax
    mov eax, 1
    int 0x80
