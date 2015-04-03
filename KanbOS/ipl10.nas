; kanb-ipl
; TAB=4


; 常量定义

CYLS	EQU		10				; 需要读取的柱面数量

		ORG		0x7c00			; 引导程序基址

; 以下定义为软盘上的FAT12标准定义

		JMP		entry
		DB		0x90
		DB		"KANBOS  "		; 启动区的名称（8B）
		DW		512				; 一个扇区的大小（必须为512B）
		DB		1				; 簇的大小（必须为1个扇区）
		DW		1				; FAT的起始位置（一般从第一个扇区开始）
		DB		2				; FAT的个数（必须为2）
		DW		224				; 根目录的大小（一般设成224项）
		DW		2880			; 该磁盘的大小（必须是2880扇区）
		DB		0xf0			; 磁盘的种类（必须是0xf0）
		DW		9				; FAT的长度（必须是9扇区）
		DW		18				; 1个磁道的扇区数（必须是18）
		DW		2				; 磁头数（单片软盘必须是2）
		DD		0				; 不适用分区，必须是0
		DD		2880			; 重写一次磁盘大小（估计是做校验使用）
		DB		0,0,0x29		
		DD		0xffffffff		
		DB		"KANBOS      "	; 磁盘名称(11B)
		DB		"FAT12   "		; 磁盘格式的名称（8B）
		RESB	18				; 空出18B

; 引导程序主体

entry:
		MOV		AX,0			; 初始化寄存器
		MOV		SS,AX
		MOV		SP,0x7c00
		MOV		DS,AX

; 读取系统本体

		MOV		AX,0x0820
		MOV		ES,AX
		MOV		CH,0			; 柱面0
		MOV		DH,0			; 磁头0
		MOV		CL,2			; 扇区2

readloop:

		MOV		SI,0			; 用于记录读取失败的次数

retry:

		MOV		AH,0x02			; AH=0x02 读盘
		MOV		AL,1			; 1个扇区
		MOV		BX,0
		MOV		DL,0x00			; A驱动器
		INT		0x13			; 调用磁盘IO（中断请求）
		JNC		next			; 没出错的情况下跳转继续读取
		ADD		SI,1			; SI加1
		CMP		SI,5			; SI和5比较
		JAE		error			; SI >= 5 的话读取出错
		MOV		AH,0x00
		MOV		DL,0x00			; A驱动器
		INT		0x13			; 系统复位
		JMP		retry

next:

		MOV		AX,ES			; 将地址后移0x200，由于段寄存器需要进位所以只需要增加0x0020即可
		ADD		AX,0x0020
		MOV		ES,AX			; 相当于ADD ES,0x020，但ES不可直接使用ADD指令
		ADD		CL,1			; CL加1
		CMP		CL,18			; CL和18比较
		JBE		readloop		; CL <= 18 的话继续读取
		MOV		CL,1
		ADD		DH,1
		CMP		DH,2
		JB		readloop		; DH < 2 继续读取背面
		MOV		DH,0
		ADD		CH,1
		CMP		CH,CYLS
		JB		readloop		; CH < CYLS 继续读取柱面

; 系统本体读取结束，跳转至系统开始运行

		MOV		[0x0ff0],CH		; 将结束地址传递给系统，实际上传递的是柱面数量
		JMP		0xc200 			;操作系统基址

error:

		MOV		SI,msg

putloop:

		MOV		AL,[SI]
		ADD		SI,1			; SI加1
		CMP		AL,0
		JE		fin
		MOV		AH,0x0e			; 打印字符
		MOV		BX,15			; 颜色代码
		INT		0x10			; 显卡IO（中断请求）
		JMP		putloop

fin:

		HLT						; 在没有任务的情况下让CPU待机
		JMP		fin				; 无限循环

msg:

		DB		0x0a, 0x0a		; 换两行
		DB		"load error"
		DB		0x0a			; 换行
		DB		0

		RESB	0x7dfe-$		; 0x7dfe前用0x00填充，从0x7c00到这个位置实际上刚好为一个扇区，为引导扇区

		DB		0x55, 0xaa
