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

    num_str: .asciz "%d%*c"  # joga fora newline do buffer
    nl_str: .asciz "\n"
    str_display: .asciz "%s\n"
    num_display: .asciz "%d\n"

    choice: .int 0
    name_input: .space 32
    cell_input: .space 32
    property_input: .space 32
    address_input: .space 32
    rooms_input: .int 0
    garage_input: .space 8
    area_input: .int 0
    rent_input: .int 0

    head: .int 0
    node_size: .int 152

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
    cmpl $2, choice
    je remove
    cmpl $6, choice
    je report

    ret

quit:
    pushl $0
    call exit

insert:
    # get name
    pushl $name_str
    call printf
    addl $4, %esp

    pushl stdin
    pushl $32
    pushl $name_input
    call fgets
    addl $12, %esp

    # get cell phone
    pushl $cell_str
    call printf
    addl $4, %esp

    pushl stdin
    pushl $32
    pushl $cell_input
    call fgets
    addl $12, %esp

    # get property type
    pushl $property_str
    call printf
    addl $4, %esp

    pushl stdin
    pushl $32
    pushl $property_input
    call fgets
    addl $12, %esp

    # get address
    pushl $address_str
    call printf
    addl $4, %esp

    pushl stdin
    pushl $32
    pushl $address_input
    call fgets
    addl $12, %esp

    # get rooms
    pushl $rooms_str
    call printf
    addl $4, %esp

    pushl $rooms_input
    pushl $num_str
    call scanf
    addl $8, %esp

    # get garage
    pushl $garage_str
    call printf
    addl $4, %esp

    pushl stdin
    pushl $32
    pushl $garage_input
    call fgets
    addl $12, %esp

    # get area
    pushl $area_str
    call printf
    addl $4, %esp

    pushl $area_input
    pushl $num_str
    call scanf
    addl $8, %esp

    # get rent
    pushl $rent_str
    call printf
    addl $4, %esp

    pushl $rent_input
    pushl $num_str
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

    # insert property type
    movl $property_input, %esi
    movl $32, %ecx
    rep movsb

    # insert address
    movl $address_input, %esi
    movl $32, %ecx
    rep movsb

    # insert rooms
    movl rooms_input, %eax  # mem with mem
    movl %eax, (%edi)

    # insert garage
    movl $garage_input, %esi
    addl $4, %edi  # skip rooms field
    movl $8, %ecx
    rep movsb

    # insert area
    movl area_input, %eax  # mem with mem
    movl %eax, (%edi)

    # insert rent
    movl rent_input, %eax  # mem with mem
    movl %eax, 4(%edi)

    ret

remove:
    movl head, %edi
    movl $0, %esi

    # check if last node
    _traverse1:
    cmpl $0, (%edi)
    je _last_node1

    # next node
    movl %edi, %esi  # store 2nd to last node
    movl (%edi), %edi
    jmp _traverse1

    # set "next" to 0 for 2nd to last node
    _last_node1:
    cmpl $0, %esi
    je _skip_next1  # if only 1 node
    movl $0, (%esi)
    _skip_next1:

    #set head to 0 if only 1 node
    cmpl $0, %esi
    jne _skip_head1  # if more than 1 node
    movl $0, head
    _skip_head1:

    # free last node pointer
    pushl %edi
    call free
    addl $4, %esp

    ret

report:
    movl head, %esi

    _loop1:
    pushl %esi  # back up start of node
    addl $4, %esi

    # [start] move strings from struct to inputs ------------------------------
    movl $name_input, %edi
    movl $32, %ecx
    rep movsb  # changes value of esi, hence backup

    movl $cell_input, %edi
    movl $32, %ecx
    rep movsb

    movl $property_input, %edi
    movl $32, %ecx
    rep movsb

    movl $address_input, %edi
    movl $32, %ecx
    rep movsb

    movl (%esi), %eax  # mem with mem
    movl %eax, rooms_input

    addl $4, %esi  # skip rooms field
    movl $garage_input, %edi
    movl $8, %ecx
    rep movsb

    movl (%esi), %eax  # mem with mem
    movl %eax, area_input

    movl 4(%esi), %eax  # mem with mem
    movl %eax, rent_input
    # [end] move strings from struct to inputs --------------------------------

    # print name
    pushl $name_input
    pushl $str_display
    call printf
    addl $8, %esp

    # print cell
    pushl $cell_input
    pushl $str_display
    call printf
    addl $8, %esp

    # print property type
    pushl $property_input
    pushl $str_display
    call printf
    addl $8, %esp

    # print address
    pushl $address_input
    pushl $str_display
    call printf
    addl $8, %esp

    # print rooms
    pushl rooms_input
    pushl $num_display
    call printf
    addl $8, %esp

    # print garage
    pushl $garage_input
    pushl $str_display
    call printf
    addl $8, %esp

    # print area
    pushl area_input
    pushl $num_display
    call printf
    addl $8, %esp

    # print rent
    pushl rent_input
    pushl $num_display
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
