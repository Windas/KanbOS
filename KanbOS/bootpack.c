#include "haribote.h"

void HariMain(void)
{
	
	struct BOOTINFO *binfo = (struct BOOTINFO*) 0x0ff0;
	extern char hankaku[4096];

	init_palette();

	init_screen(binfo->vram, binfo->scrnx, binfo->scrny);

	putfont8(binfo->vram, binfo->scrnx,  8, 8, COL8_FFFFFF, hankaku + 'A' * 16);
	putfont8(binfo->vram, binfo->scrnx, 16, 8, COL8_FFFFFF, hankaku + 'B' * 16);
	putfont8(binfo->vram, binfo->scrnx, 24, 8, COL8_FFFFFF, hankaku + 'C' * 16);
	putfont8(binfo->vram, binfo->scrnx, 40, 8, COL8_FFFFFF, hankaku + '1' * 16);
	putfont8(binfo->vram, binfo->scrnx, 48, 8, COL8_FFFFFF, hankaku + '2' * 16);
	putfont8(binfo->vram, binfo->scrnx, 56, 8, COL8_FFFFFF, hankaku + '3' * 16);

	for (;;) {
		io_hlt();
	}
}

void init_palette(void)
{
	static unsigned char table_rgb[16 * 3] = {
		0x00, 0x00, 0x00,	/*  0:黑 */
		0xff, 0x00, 0x00,	/*  1:亮红 */
		0x00, 0xff, 0x00,	/*  2:亮绿 */
		0xff, 0xff, 0x00,	/*  3:亮黄 */
		0x00, 0x00, 0xff,	/*  4:亮蓝 */
		0xff, 0x00, 0xff,	/*  5:亮紫 */
		0x00, 0xff, 0xff,	/*  6:浅亮蓝 */
		0xff, 0xff, 0xff,	/*  7:白 */
		0xc6, 0xc6, 0xc6,	/*  8:亮灰*/
		0x84, 0x00, 0x00,	/*  9:暗红 */
		0x00, 0x84, 0x00,	/* 10:暗绿 */
		0x84, 0x84, 0x00,	/* 11:暗黄 */
		0x00, 0x00, 0x84,	/* 12:暗青 */
		0x84, 0x00, 0x84,	/* 13:暗紫 */
		0x00, 0x84, 0x84,	/* 14:浅暗蓝 */
		0x84, 0x84, 0x84	/* 15:暗灰 */
	};

	set_palette(0, 15, table_rgb);

	return;
}

void set_palette(int start, int end, unsigned char *rgb)
{

	int eflags = io_load_eflags();	/* 记录中断许可 */
	
	io_cli(); 					/* 将中断许可标志置为0，这样该过程是不可中断的 */
	io_out8(0x03c8, start);
	
	for (int i = start; i <= end; i++) {
		io_out8(0x03c9, rgb[0] / 4);
		io_out8(0x03c9, rgb[1] / 4);
		io_out8(0x03c9, rgb[2] / 4);
		rgb += 3;
	}

	io_store_eflags(eflags);	/* 复原中断标志 */
	
	return;
}

void boxfill8(unsigned char *vram, int xsize, unsigned char c, int x0, int y0, int x1, int y1)
{

	int x, y;
	for (y = y0; y <= y1; y++) {
		for (x = x0; x <= x1; x++)
			vram[y * xsize + x] = c;
	}

	return;
}

void init_screen(char* vram, int x, int y)
{

	//绘制界面
	boxfill8(vram, x, COL8_000000,  0,         0,          x -  1, y - 20);
	boxfill8(vram, x, COL8_C6C6C6,  0,         y - 19, x -  1, y - 19);
	boxfill8(vram, x, COL8_FFFFFF,  0,         y - 18, x -  1, y - 18);
	boxfill8(vram, x, COL8_C6C6C6,  0,         y - 17, x -  1, y -  1);

	boxfill8(vram, x, COL8_FFFFFF,  3,         y - 15, 50,         y - 15);
	boxfill8(vram, x, COL8_FFFFFF,  2,         y - 15,  2,         y -  4);
	boxfill8(vram, x, COL8_848484,  3,         y -  4, 50,         y -  4);
	boxfill8(vram, x, COL8_848484, 50,         y - 14, 50,         y -  5);
	boxfill8(vram, x, COL8_000000,  2,         y -  3, 50,         y -  3);
	boxfill8(vram, x, COL8_000000, 51,         y - 15, 51,         y -  3);

	boxfill8(vram, x, COL8_848484, x - 47, y - 15, x -  4, y - 15);
	boxfill8(vram, x, COL8_848484, x - 47, y - 14, x - 47, y -  4);
	boxfill8(vram, x, COL8_FFFFFF, x - 47, y -  3, x -  4, y -  3);
	boxfill8(vram, x, COL8_FFFFFF, x -  3, y - 15, x -  3, y -  3);

	return;
}

void putfont8(char* vram, int xsize, int x, int y, char c, char* font)
{
	char d; 	//data
	char* p;

	for (int i = 0; i < 16; i++) {
		p = vram + (y + i) * xsize + x;
		d = font[i];

		if ((d & 0x80) != 0) { p[0] = c; }
		if ((d & 0x40) != 0) { p[1] = c; }
		if ((d & 0x20) != 0) { p[2] = c; }
		if ((d & 0x10) != 0) { p[3] = c; }
		if ((d & 0x08) != 0) { p[4] = c; }
		if ((d & 0x04) != 0) { p[5] = c; }
		if ((d & 0x02) != 0) { p[6] = c; }
		if ((d & 0x01) != 0) { p[7] = c; }
	}

	return;
}
