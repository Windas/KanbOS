; Kanb-OS
; TAB=4

CYLS 	EQU 	10 				;需要读取的柱面数量

		ORG		0x7c00			;系统基址

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
		MOV		AX,0			;初始化寄存器
		MOV		SS,AX
		MOV		SP,0x7c00
		MOV		DS,AX

;读取磁盘
		
		MOV 	AX,0x0820		;除BIOS引导区以外的系统基址
		MOV 	ES,AX 			
		MOV 	CH,0 			;柱面0
		MOV 	DH,0 			;磁头0
		MOV		CL,2 			;扇区2

readloop:
		MOV 	SI,0 			;用于记录读取失败的次数

retry:
		MOV		AH,0x02 		;读盘
		MOV 	AL,1 			;读取一个扇区
		MOV 	BX,0 			;偏移地址0
		MOV 	DL,0x00 		;A驱动器
		INT 	0x13 			;磁盘IO中断号
		JNC 	next 			;成功即转入下个扇区读取
		ADD 	SI,1 			;否则失败，记录次数加1
		CMP 	SI,5 			;SI与5比较
		JAE 	error 			;大于等于5次则抛出异常，停止读取
		MOV 	AH,0x00 		;否则系统复位，重新读取
		MOV 	DL,0x00
		INT 	0x13
		JMP 	retry

next:
		ADD 	BX,0x200 		;将地址指针向后移动一个扇区的大小（512B）
		ADD 	CL,1 			;扇区号增加1
		CMP 	CL,18 			;直到读取到18扇区
		JBE 	readloop 		;如果未读取完毕则继续读取
		MOV		CL,1 			;扇区重置为1
		ADD 	DH,1 			;磁头加1，实际上可以直接赋值为1
		CMP 	DH,2
		JB 		readloop 		;小于2时，需要跳转至readloop读取内容
		MOV 	DH,0 			;第二面的柱面1读取完毕，磁头切换为0
		ADD 	CH,1 			;开始读取第二柱面
		CMP 	CH,CYLS 		;读取直到第十次
		JB 		readloop

		MOV 	SI,suc 		;读取结束输出成功信息
		JMP 	putloop

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
		JE 		last
		MOV 	AH,0x0e			;文字显示指令
		MOV 	BX,15
		INT 	0x10			;显卡中断号
		JMP 	putloop

msg:
		DB 		0x0a, 0x0a		;换两行
		DB 		"load error"
		DB 		0x0a			;换行
		DB 		0

suc:
		DB 		0x0a, 0x0a 		;换两行
		DB 		"reading success"
		DB 		0x0a 			;换行
		DB 		0

last:
		
		RESB 	0x7dfe-$ 		;填充0x00

		DB 		0x55, 0xaa 		;启动校验位
		JMP 	fin