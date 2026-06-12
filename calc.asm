section .data
    msg_result  db "Result: "
    msg_result_len equ $ - msg_result
    msg_usage      db "Usage: ./calc <num1> <op> <num2>", 10
    msg_usage_len  equ $ - msg_usage
    msg_divzero    db "Error: division by zero", 10
    msg_divzero_len equ $ - msg_divzero
    msg_badop      db "Error: unknown operator", 10
    msg_badop_len  equ $ - msg_badop
    msg_badarg     db "Error: invalid argument", 10
    msg_badarg_len equ $ - msg_badarg
    msg_minus   db "-"
    newline     db 10

section .bss
    buffer    resb 20
    parse_err resb 1

section .text
    global _start

print_number:
    push edi
    push esi
    push ecx
    push edx
    push ebx

    push eax
    test eax, eax
    jge .convert_start
    neg eax

.convert_start:
    lea ecx, [buffer + 19]
    mov edi, ecx
    mov ebx, 10

.convert:
    xor edx, edx
    div ebx
    add dl, '0'
    dec ecx
    mov [ecx], dl
    test eax, eax
    jnz .convert

    push ecx
    mov edx, msg_result_len
    mov ecx, msg_result
    mov ebx, 1
    mov eax, 4
    int 0x80
    pop ecx

    pop eax
    test eax, eax
    jge .print_digits
    push ecx
    mov edx, 1
    mov ecx, msg_minus
    mov ebx, 1
    mov eax, 4
    int 0x80
    pop ecx

.print_digits:
    mov edx, edi
    sub edx, ecx
    mov ebx, 1
    mov eax, 4
    int 0x80

    mov edx, 1
    mov ecx, newline
    mov ebx, 1
    mov eax, 4
    int 0x80

    pop ebx
    pop edx
    pop ecx
    pop esi
    pop edi
    ret

atoi:
    xor eax, eax
    xor ecx, ecx

    mov byte [parse_err], 0

    cmp byte [esi], '-'
    jne .check_first
    inc cl
    inc esi

.check_first:
    movzx edx, byte [esi]
    cmp edx, '0'
    jl .invalid
    cmp edx, '9'
    jg .invalid

.loop:
    movzx edx, byte [esi]
    cmp edx, '0'
    jl .done
    cmp edx, '9'
    jg .done
    sub edx, '0'
    imul eax, 10
    add eax, edx
    inc esi
    jmp .loop

.invalid:
    mov byte [parse_err], 1

.done:
    test cl, cl
    jz .end
    neg eax
.end:
    ret

_start:
    mov ebp, esp

    cmp dword [ebp], 4
    jne .usage

    mov esi, [ebp + 8]
    call atoi
    cmp byte [parse_err], 1
    je .badarg
    mov edi, eax

    mov esi, [ebp + 12]
    movzx ebx, byte [esi]

    mov esi, [ebp + 16]
    call atoi
    cmp byte [parse_err], 1
    je .badarg
    mov esi, eax

    mov eax, edi

    cmp bl, '+'
    je .add
    cmp bl, '-'
    je .sub
    cmp bl, '*'
    je .mul
    cmp bl, '/'
    je .div
    jmp .badop

.add:
    add eax, esi
    jmp .print
.sub:
    sub eax, esi
    jmp .print
.mul:
    imul eax, esi
    jmp .print
.div:
    test esi, esi
    jz .divzero
    cdq
    idiv esi
    jmp .print

.divzero:
    mov edx, msg_divzero_len
    mov ecx, msg_divzero
    mov ebx, 2
    mov eax, 4
    int 0x80
    mov eax, 1
    mov ebx, 1
    int 0x80

.print:
    call print_number
    jmp .exit

.badarg:
    mov edx, msg_badarg_len
    mov ecx, msg_badarg
    mov ebx, 2
    mov eax, 4
    int 0x80
    mov eax, 1
    mov ebx, 1
    int 0x80

.badop:
    mov edx, msg_badop_len
    mov ecx, msg_badop
    mov ebx, 2
    mov eax, 4
    int 0x80
    mov eax, 1
    mov ebx, 1
    int 0x80

.usage:
    mov edx, msg_usage_len
    mov ecx, msg_usage
    mov ebx, 1
    mov eax, 4
    int 0x80

.exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80
