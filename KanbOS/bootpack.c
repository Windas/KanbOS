void io_hlt(void); 					//使CPU进入待机状态
void io_cli(void); 					//将中断标志位置0
void io_out8(int port, int data); 
int io_load_eflags(void);
void io_store_eflags(int eflags);


void init_palette(void);
void set_palette(int start, int end, unsigned char* rgb);

void HariMain(void)
{

	char* p = 0;

	init_palette();

	for (int i = 0xa0000; i <= 0xaffff; i++) {
		*(p + i) = 9; 
	}

	for ( ; ; ) {
		io_hlt();
	}
}

void init_palette(void)
{
	static unsigned char table_rgb[16 * 3] = {
		0x00, 0x00, 0x00, 			//#000000黑
		0xff, 0x00, 0x00, 			//#ff0000亮红
		0xff, 0xff, 0x00, 			//#00ff00亮绿
		0x00, 0x00, 0xff, 			//#0000ff亮蓝
		0xff, 0x00, 0xff, 			//#ff00ff亮紫
		0x00, 0xff, 0xff, 			//#00ffff浅亮蓝
		0xff, 0xff, 0xff, 			//#ffffff白色
		0xc6, 0xc6, 0xc6, 			//#c6c6c6亮灰
		0x84, 0x00, 0x00, 			//#840000暗红
		0x00, 0x84, 0x00, 			//#008400暗绿
		0x84, 0x84, 0x00, 			//#848400暗黄
		0x00, 0x00, 0x84, 			//#000084暗青
		0x84, 0x00, 0x84, 			//#840084暗紫
		0x00, 0x84, 0x84,			//#008484浅暗蓝
		0x84, 0x84, 0x84 			//#848484暗灰
	};

	set_palette(0, 15, table_rgb); 	//设定调色板信息

	return;
}

void set_palette(int start, int end, unsigned char* rgb)
{
	int eflags = io_load_eflags(); 		//记录中断许可标志的值
	io_cli(); 						//将许可标志置为0，禁止中断
	io_out8(0x03c8, start);
	for (int i = start; i <= end; i++) {
		io_out8(0x03c9, rgb[0] / 4);
		io_out8(0x03c9, rgb[1] / 4);
		io_out8(0x03c9, rgb[2] / 4);

		rgb += 3;
	}

	io_store_eflags(eflags); 		//恢复许可标志的值
	
	return;
}
