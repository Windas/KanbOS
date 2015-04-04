#define COL8_000000		0
#define COL8_FF0000 	1
#define COL8_00FF00 	2
#define COL8_FFFF00 	3
#define COL8_0000FF 	4
#define COL8_FF00FF 	5
#define COL8_00FFFF 	6
#define COL8_FFFFFF 	7
#define COL8_C6C6C6 	8
#define COL8_840000 	9
#define COL8_008400 	10
#define COL8_848400 	11
#define COL8_000084 	12
#define COL8_840084 	13
#define COL8_008484 	14
#define COL8_848484 	15

void io_hlt(void); 					//使CPU进入待机状态
void io_cli(void); 					//将中断标志位置0
void io_out8(int port, int data); 
int io_load_eflags(void);
void io_store_eflags(int eflags);


void init_palette(void);
void set_palette(int start, int end, unsigned char* rgb);
void boxfill8(unsigned char *vram, int xsize, unsigned char c, int x0, int y0, int x1, int y1);


void HariMain(void)
{

	char* p = (char*) 0xa0000;

	init_palette();

	boxfill8(p, 320, COL8_FF0000, 20, 20, 120, 120);
	boxfill8(p, 320, COL8_00FF00, 70, 50, 170, 150);
	boxfill8(p, 320, COL8_0000FF, 120, 80, 220, 180);

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

void boxfill8(unsigned char *vram, int xsize, unsigned char c, int x0, int y0, int x1, int y1)
{
	for (int y = y0; y <= y1; y++) {
		for (int x = x0; x <= x1; x++)
			vram[y * xsize + x] = c;
	}
}