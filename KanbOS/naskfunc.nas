; naskfunc
; TAB=4

[FORMAT "WCOFF"]				; 制作目标文件的模式	
[BITS 32]						; 生成32bit的机器语言


; 目标文件信息

[FILE "naskfunc.nas"]			; 源文件信息

		GLOBAL	_io_hlt			; 程序中的函数名


; 实际的函数实现

[SECTION .text]		

_io_hlt:	; void io_hlt(void);
		HLT
		RET
