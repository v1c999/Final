INCLUDE Irvine32.inc
sj24 PROTO

boxSize = 4

.data
boxSquare BYTE boxSize * boxSize DUP(0)
generateList BYTE 8 DUP(2), 4

main EQU start@0
.code
input PROC
	call ReadChar
    .IF ax == 4D00h ;RIGHT ARROW
		mov eax, 11
	.ELSEIF ax == 4B00h ;LEFT ARROW
		mov eax, 12
	.ELSEIF ax == 4800h ;UP ARROW
		mov eax, 21
	.ELSEIF ax == 5000h ;DOWN ARROW
		mov eax, 22
    .ELSE
        mov eax, 33
	.ENDIF

    ret
input ENDP

move PROC
    mov ecx, 0

	mov ebx, 10
    mov edx, 0
	INVOKE input
	div ebx

	.IF al == 1
		.IF dl == 1 ; RIGHT ARROW

        right_i_loop:
			mov edx, 0
			mov esi, 0
            mov edi, 0
		right_j_loop:
			; 計算a[i][j]在陣列中的偏移
            mov eax, ecx
            imul eax, boxSize
            add eax, esi

            ; 檢查a[i][j-1]==0
            
            mov ebx, 0
            cmp [boxSquare + eax], bl
            jne right_not_zero

            ; 如果為0，則將a[i][j-1]設置為a[i][j]
            cmp edi, ebx
            je right_not_meet_nonzero
            mov bl, [boxSquare + eax - 1]
            mov [boxSquare + eax], bl

            ; 將a[i][j]設置為0
            mov bl, 0
            mov [boxSquare + eax - 1], bl
            mov edi, 0
            mov esi, 0
            jmp right_j_loop
        
        right_not_meet_nonzero:
            inc esi
            cmp esi, boxSize
            jl right_j_loop
            mov esi, 0
            jmp right_j_add_loop
		right_not_zero:
            ; 減小j
            inc edi
            inc esi
            cmp esi, boxSize
            jl right_j_loop
            mov esi, 0
            jmp right_j_add_loop

        ; 第二步，將相鄰兩兩相同的數相加，賦值前者，後者賦0
		right_j_add_loop:
            ; 計算a[i][j]在陣列中的偏移
            mov eax, ecx
            imul eax, boxSize
            add eax, esi

            ; 檢查a[i][j]是否等於a[i][j+1]
            mov bl, [boxSquare + eax + 1]
            cmp [boxSquare + eax], bl
            jne right_not_equal

            ; 如果相等，將a[i][j]加上a[i][j+1]，並將a[i][j+1]設置為0
            mov bl, [boxSquare + eax]
            add [boxSquare + eax + 1], bl
            mov bl, 0
            mov [boxSquare + eax], bl
            cmp [boxSquare + eax + 1], bl
            jne right_i_loop

        right_not_equal:
            ; 增加j
            inc esi
            cmp esi, boxSize - 1
            jl right_j_add_loop
            mov esi, 0

        ; 增加i
        inc ecx
        cmp ecx, boxSize
        jl right_i_loop

		.ELSEIF dl == 2 ; LEFT ARROW

		left_i_loop:
			mov edx, 0
			mov esi, boxSize
            mov edi, 0
		left_j_loop:
			; 計算a[i][j]在陣列中的偏移
            mov eax, ecx
            imul eax, boxSize
            add eax, esi

            ; 檢查a[i][j-1]==0
            
            mov ebx, 0
            cmp [boxSquare + eax - 1], bl
            jne left_not_zero

            ; 如果為0，則將a[i][j-1]設置為a[i][j]
            cmp edi, ebx
            je left_not_meet_nonzero
            mov bl, [boxSquare + eax]
            mov [boxSquare + eax - 1], bl

            ; 將a[i][j]設置為0
            mov bl, 0
            mov [boxSquare + eax], bl
            mov edi, 0
            mov esi, boxSize
            jmp left_j_loop
        
        left_not_meet_nonzero:
            dec esi
            jg left_j_loop
            mov esi, boxSize - 1
            jmp left_j_add_loop
		left_not_zero:
            ; 減小j
            inc edi
            dec esi
            jg left_j_loop
            mov esi, boxSize - 1
            jmp left_j_add_loop

        ; 第二步，將相鄰兩兩相同的數相加，賦值前者，後者賦0
		left_j_add_loop:
            ; 計算a[i][j]在陣列中的偏移
            mov eax, ecx
            imul eax, boxSize
            add eax, esi

            ; 檢查a[i][j]是否等於a[i][j+1]
            mov bl, [boxSquare + eax]
            cmp [boxSquare + eax - 1], bl
            jne left_not_equal

            ; 如果相等，將a[i][j]加上a[i][j+1]，並將a[i][j+1]設置為0
            mov bl, [boxSquare + eax]
            add [boxSquare + eax - 1], bl
            mov bl, 0
            mov [boxSquare + eax], bl
            cmp [boxSquare + eax - 1], bl
            jne left_i_loop

        left_not_equal:
            ; 增加j
            dec esi
            jg left_j_add_loop
            mov esi, 0

        ; 增加i
        inc ecx
        cmp ecx, boxSize
        jl left_i_loop

		.ENDIF
	.ELSEIF al == 2
		.IF dl == 1 ; UP ARROW
        
		up_i_loop:
			mov edx, 0
			mov esi, boxSize
            mov edi, 0
		up_j_loop:
			; 計算a[i][j]在陣列中的偏移
            mov eax, esi
            imul eax, boxSize
            add eax, ecx

            ; 檢查a[i][j-1]==0
            
            mov ebx, 0
            cmp [boxSquare + eax - boxSize], bl
            jne up_not_zero

            ; 如果為0，則將a[i][j-1]設置為a[i][j]
            cmp edi, ebx
            je up_not_meet_nonzero
            mov bl, [boxSquare + eax]
            mov [boxSquare + eax - boxSize], bl

            ; 將a[i][j]設置為0
            mov bl, 0
            mov [boxSquare + eax], bl
            mov edi, 0
            mov esi, boxSize
            jmp up_j_loop
        
        up_not_meet_nonzero:
            dec esi
            jg up_j_loop
            mov esi, boxSize - 1
            jmp up_j_add_loop
		up_not_zero:
            ; 減小j
            inc edi
            dec esi
            jg up_j_loop
            mov esi, boxSize - 1
            jmp up_j_add_loop

        ; 第二步，將相鄰兩兩相同的數相加，賦值前者，後者賦0
		up_j_add_loop:
            ; 計算a[i][j]在陣列中的偏移
            mov eax, esi
            imul eax, boxSize
            add eax, ecx

            ; 檢查a[i][j]是否等於a[i][j+1]
            mov bl, [boxSquare + eax]
            cmp [boxSquare + eax - boxSize], bl
            jne up_not_equal

            ; 如果相等，將a[i][j]加上a[i][j+1]，並將a[i][j+1]設置為0
            mov bl, [boxSquare + eax]
            add [boxSquare + eax - boxSize], bl
            mov bl, 0
            mov [boxSquare + eax], bl
            cmp [boxSquare + eax], bl
            jne up_i_loop

        up_not_equal:
            ; 增加j
            dec esi
            jg up_j_add_loop
            mov esi, 0

        ; 增加i
        inc ecx
        cmp ecx, boxSize
        jl up_i_loop

		.ELSEIF dl == 2 ; DOWN ARROW
        
        down_i_loop:
			mov edx, 0
			mov esi, 0
            mov edi, 0
		down_j_loop:
			; 計算a[i][j]在陣列中的偏移
            mov eax, esi
            imul eax, boxSize
            add eax, ecx

            ; 檢查a[i][j-1]==0
            
            mov ebx, 0
            cmp [boxSquare + eax], bl
            jne down_not_zero

            ; 如果為0，則將a[i][j-1]設置為a[i][j]
            cmp edi, ebx
            je down_not_meet_nonzero
            mov bl, [boxSquare + eax - boxSize]
            mov [boxSquare + eax], bl

            ; 將a[i][j]設置為0
            mov bl, 0
            mov [boxSquare + eax - boxSize], bl
            mov edi, 0
            mov esi, 0
            jmp down_j_loop
        
        down_not_meet_nonzero:
            inc esi
            cmp esi, boxSize
            jl down_j_loop
            mov esi, 0
            jmp down_j_add_loop
		down_not_zero:
            ; 減小j
            inc edi
            inc esi
            cmp esi, boxSize
            jl down_j_loop
            mov esi, 0
            jmp down_j_add_loop

        ; 第二步，將相鄰兩兩相同的數相加，賦值前者，後者賦0
		down_j_add_loop:
            ; 計算a[i][j]在陣列中的偏移
            mov eax, esi
            imul eax, boxSize
            add eax, ecx

            ; 檢查a[i][j]是否等於a[i][j+1]
            mov bl, [boxSquare + eax + boxSize]
            cmp [boxSquare + eax], bl
            jne down_not_equal

            ; 如果相等，將a[i][j]加上a[i][j+1]，並將a[i][j+1]設置為0
            mov bl, [boxSquare + eax]
            add [boxSquare + eax + boxSize], bl
            mov bl, 0
            mov [boxSquare + eax], bl
            cmp [boxSquare + eax + boxSize], bl
            jne down_i_loop

        down_not_equal:
            ; 增加j
            inc esi
            cmp esi, boxSize - 1
            jl down_j_add_loop
            mov esi, 0

        ; 增加i
        inc ecx
        cmp ecx, boxSize
        jl down_i_loop

		.ENDIF
        .ELSE
            INVOKE input
	.ENDIF

    ret
move ENDP

get PROC
    mov eax, 0; 第幾個element
    mov ebx, boxSize * boxSize; element總數
    mov ecx, 0; 幾個非0值
    mov esi, 0

    mov dl, 0
    get_check_loop:
        cmp [boxSquare + eax], dl
        jne get_not_zero
        push eax
        inc ecx
    
    get_not_zero:
        inc eax
        cmp eax, ebx
        jl get_check_loop
    
    get_test_square_full:
        ; 這裡之後要加結束的判斷式
        cmp ecx, esi
        mov ebx, ecx
        je get_is_full
        mov edx, 0
        rdrand eax
        div ecx
        mov ecx, 0

    get_replace_zero:
        dec ebx
        pop eax
        cmp ebx, ecx
        je get_end_phase
        cmp edx, ebx
        jne get_replace_zero
        mov esi, eax
        push ecx
        push edx
        INVOKE sj24
        mov [boxSquare + esi], al
        pop edx
        pop ecx
        jmp get_replace_zero

    get_is_full:
        dec ebx
        pop eax
        cmp ebx, ecx
        je get_is_full
        ret

    get_end_phase:
        ret
get ENDP
    
init PROC
    mov ebx, boxSize * boxSize; element總數
    mov ecx, 0; 幾個非0值
    mov edx, 0
    
    rdrand eax
    div ebx
    mov ecx, edx

    init_second_time:
        mov edx, 0
        rdrand eax
        div ebx
        cmp ecx, edx
        je init_second_time
        push ecx
        push edx
        INVOKE sj24
        pop ecx
        mov [boxSquare + ecx], al
        pop edx
        INVOKE sj24
        mov [boxSquare + edx], al
        ret

init ENDP

sj24 PROC
    mov ecx, 9
    mov edx, 0
    rdrand eax
    div ecx
    movzx eax, [generateList + edx]
    ret
sj24 ENDP

main PROC
    mov esi, OFFSET boxSquare

    INVOKE init ; 用兩個2或4添加到boxSquare裡進行初始化

    game_loop:
        INVOKE get ; 添加2或4到boxSquare裡
        INVOKE move ; 接收上下左右，然後更新陣列
        jmp game_loop

	    call WaitMsg
	    call Clrscr
	exit
main ENDP
END main
