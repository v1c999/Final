INCLUDE Irvine32.inc

input PROTO
move PROTO

boxSize = 4

.data
boxSquare BYTE  2, 0, 2, 2,
                0, 0, 0, 0,
                4, 8, 2, 2,
                0, 2, 2, 0

consoleHandle DWORD ?
outputHandle DWORD 0

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
	.ENDIF

    ret
move ENDP

main PROC
    mov esi, OFFSET boxSquare

    game_loop:
        INVOKE move
        jmp game_loop
	
    mov ax, 0
	   call WaitMsg
	   call Clrscr
	exit
main ENDP
END main
