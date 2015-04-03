; kanbos-os
; TAB=4

		ORG 	0xc200			;启动区从0x8000载入系统级镜像，系统本体偏移地址为0x4200，因此系统将从0xc200处被读取

		MOV 	AL,0x13
		MOV  	AH,0x00
		INT 	0x10

fin:
		HLT
		JMP		fin
