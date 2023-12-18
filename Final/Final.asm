include Irvine32.inc
.data
.code 
main PROC
	mov al,00110000b
	mov ah,29d
	mov ax,3530h
	mov dx,0eeeah
	sub dx,ax
main ENDP 
END main

