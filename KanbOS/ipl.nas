; hello-os
; TAB=4

		ORG		0x7c00			; 系统基址

; 以下内容针对FAT12标准设置

		JMP		entry
		DB		0x90
		DB		"HELLOIPL"		
		DW		512				
		DB		1				
		DW		1				
		DB		2				
		DW		224				
		DW		2880			
		DB		0xf0			
		DW		9				
		DW		18				
		DW		2				
		DD		0				
		DD		2880			
		DB		0,0,0x29		
		DD		0xffffffff		
		DB		"HELLO-OS   "	
		DB		"FAT12   "		
		RESB	18				

; 系统本体

entry:
		MOV		AX,0			; 初始化AX寄存器
		MOV		SS,AX
		MOV		SP,0x7c00
		MOV		DS,AX
		MOV		ES,AX

		MOV		SI,msg
putloop:
		MOV		AL,[SI]
		ADD		SI,1			; SI加一
		CMP		AL,0
		JE		fin
		MOV		AH,0x0e			
		MOV		BX,15			
		INT		0x10			; 呼出显卡BIOS
		JMP		putloop
fin:
		HLT						; 使CPU进入待机状态
		JMP		fin				; 无限循环

msg:
		DB		0x0a, 0x0a		; 换两行
		DB		"hello, world"
		DB		0x0a			; 换行
		DB		0

		RESB	0x7dfe-$		; 使用0x00填充直到0x7dfe

		DB		0x55, 0xaa		; 操作系统引导辨识码
