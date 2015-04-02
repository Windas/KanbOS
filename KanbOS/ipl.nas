; hello-os
; TAB=4

		ORG		0x7c00			; 系统基址

; 以下内容针对FAT12标准设置

		JMP		entry
		DB		0x90
		DB		"KANBOS  "		
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
		DB		"KANB-OS    "	
		DB		"FAT12   "		
		RESB	18				

; 系统本体

entry:
		MOV		AX,0			; 初始化寄存器
		MOV		SS,AX
		MOV		SP,0x7c00
		MOV		DS,AX

;读取磁盘
		
		MOV 	AX,0x0820		;除BIOS引导区以外的系统基址
		MOV 	ES,AX 			
		MOV 	CH,0 			;柱面0
		MOV 	DH,0 			;磁头0
		MOV		CL,2 			;扇区2

		MOV 	SI,0 			;用于记录读取失败的次数

retry:
		MOV		AH,0x02 		;读盘
		MOV 	AL,1 			;读取一个扇区
		MOV 	BX,0 			;偏移地址0
		MOV 	DL,0x00 		;A驱动器
		INT 	0x13 			;磁盘IO中断号
		JNC 	fin 			;成功即转入fin
		ADD 	SI,1 			;否则失败，记录次数加1
		CMP 	SI,5 			;SI与5比较
		JAE 	error 			;大于等于5次则抛出异常，停止读取
		MOV 	AH,0x00 		;否则系统复位，重新读取
		MOV 	DL,0x00
		INT 	0x13
		JMP 	retry


;读取结束后使CPU进入待机状态

fin:
		HLT						;CPU待机
		JMP		fin				;无限循环

error:
		MOV 	SI,msg

putloop:
		MOV 	AL,[SI]
		ADD 	SI,1
		CMP 	AL,0
		JE 		fin
		MOV 	AH,0x0e			;文字显示指令
		MOV 	BX,15
		INT 	0x10			;显卡中断号
		JMP 	putloop

msg:
		DB 		0x0a, 0x0a		;换两行
		DB 		"load error"
		DB 		0x0a			;换行
		DB 		0

		RESB 	0x7dfe-$		;填充0x00

		DB 		0x55, 0xaa		;启动校验位