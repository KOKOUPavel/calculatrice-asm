section .data
    msg db "Result: ", 0
    newline db 10, 0

section .bss
    buffer resb 16

section .text
    global _start

_start:
    mov eax, 12
    mov ebx, 4
    add eax, ebx

    mov ecx, buffer + 15
    mov ebx, 10
    mov edi, ecx

convert_loop:
    xor edx, edx
    div ebx
    add dl, '0'
    dec ecx
    mov [ecx], dl
    test eax, eax
    jnz convert_loop

    push ecx
    mov edx, 8
    mov ecx, msg
    mov ebx, 1
    mov eax, 4
    int 0x80
    pop ecx

    mov edx, edi
    sub edx, ecx
    mov eax, 4
    mov ebx, 1
    int 0x80

    mov edx, 1
    mov ecx, newline
    mov eax, 4
    mov ebx, 1
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80
