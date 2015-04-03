; naskfunc
; TAB=4

[FORMAT "WCOFF"]				; 制作目标文件的模式
[INSTRSET "i486p"]				; 声明在486上运行的指令	
[BITS 32]						; 生成32bit的机器语言


; 目标文件信息

[FILE "naskfunc.nas"]			; 源文件信息

		GLOBAL	_io_hlt,_write_mem8			; 程序中的函数名


; 实际的函数实现

[SECTION .text]		

_io_hlt:	; void io_hlt(void);
		HLT
		RET

_write_mem8:
		MOV 	ECX,[ESP+4] 	; 第一个参数
		MOV 	AL,[ESP+8] 		; 第二个参数（因为均为整型，32bit下整型为4字节）
		MOV 	[ECX],AL 
		RET