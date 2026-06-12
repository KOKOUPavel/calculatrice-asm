section .data
    num1 dd 12
    num2 dd 4
    op   db '+'

section .text
    global _start

_start:
    mov eax, [num1]
    mov ebx, [num2]
    mov cl, [op]

    cmp cl, '+'
    je do_add
    cmp cl, '-'
    je do_sub
    cmp cl, '*'
    je do_mul
    cmp cl, '/'
    je do_div

do_add:
    add eax, ebx
    jmp done

do_sub:
    sub eax, ebx
    jmp done

do_mul:
    mul ebx
    jmp done

do_div:
    div ebx
    jmp done

done:
    mov ebx, eax
    mov eax, 1
    int 0x80
