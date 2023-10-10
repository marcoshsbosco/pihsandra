/*
Bosco - RA117873
Mafe - RA
Vitor Grabski - RA
*/


.section .data
    menu_str: .asciz "\n1. Inserção\n2. Remoção\n3. Consulta\n4. Gravar\n5. Recuperar\n6. Relatório\n0. Sair\n"
    name_str: .asciz "Nome do proprietário: "
    cell_str: .asciz "Celular do proprietário: "
    property_str: .asciz "Tipo do imóvel: "
    address_str: .asciz "Endereço do imóvel: "
    rooms_str: .asciz "Número de quartos: "
    garage_str: .asciz "Garagem: "
    area_str: .asciz "Metragem total: "
    rent_str: .asciz "Valor do aluguel: "

    num_str: .asciz "%d"
    str_str: .asciz "%s"
    nl_str: .asciz "\n"
    str_display: .asciz "%s\n"

    choice: .int 0
    name_input: .space 32
    cell_input: .space 32

    head: .int 0
    node_size: .int 68

.section .bss
.section .text
.globl _start
_start:
    call menu

    jmp _start

menu:
    # show options menu
    pushl $menu_str
    call printf
    addl $4, %esp

    # get user choice
    pushl $choice
    pushl $num_str
    call scanf
    addl $8, %esp

    # print nl
    pushl $nl_str
    call printf
    addl $4, %esp

    # call appropriate function
    cmpl $0, choice
    je quit
    cmpl $1, choice
    je insert
    cmpl $6, choice
    je ll_print

    ret

quit:
    pushl $0
    call exit

insert:
    # get name
    pushl $name_str
    call printf
    addl $4, %esp

    pushl $name_input
    pushl $str_str
    call scanf
    addl $8, %esp

    # get cell phone
    pushl $cell_str
    call printf
    addl $4, %esp

    pushl $cell_input
    pushl $str_str
    call scanf
    addl $8, %esp

    # inserts all in node in list
    call ll_insert

    ret

ll_insert:
    movl head, %edi

    # check if last node
    cmpl $0, head
    je _link
    _traverse:
    cmpl $0, (%edi)
    je _link

    # next node
    movl (%edi), %edi
    jmp _traverse

    # create new node
    _link:
    pushl node_size
    call malloc
    addl $4, %esp

    # set head if new list
    cmpl $0, head
    jne _skip_head
    movl %eax, head
    _skip_head:

    # set last node's "next"
    cmpl $0, %edi
    je _skip_next
    movl %eax, (%edi)
    _skip_next:

    # insert name
    movl $name_input, %esi
    movl %eax, %edi
    addl $4, %edi
    movl $32, %ecx
    rep movsb

    # insert cell
    movl $cell_input, %esi
    movl $32, %ecx
    rep movsb

    ret

ll_print:
    movl head, %esi

    _loop1:
    pushl %esi  # back up start of node
    addl $4, %esi

    # move strings from struct to inputs
    movl $name_input, %edi
    movl $32, %ecx
    rep movsb  # changes value of esi, hence backup

    movl $cell_input, %edi
    movl $32, %ecx
    rep movsb

    # print string
    pushl $name_input
    pushl $str_display
    call printf
    addl $8, %esp

    pushl $cell_input
    pushl $str_display
    call printf
    addl $8, %esp

    popl %esi  # restore start of node

    # next node if exists
    cmpl $0, (%esi)
    je _end_print

    movl (%esi), %esi  # next node

    # print nl
    pushl $nl_str
    call printf
    addl $4, %esp

    jmp _loop1  # print again
    _end_print:

    ret
