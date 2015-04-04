void io_hlt(void);

void HariMain(void)
{

	char* p;

	for (int i = 0xa0000; i <= 0xaffff; i++) {
		*(p + i) = 9; 
	}

	for ( ; ; ) {
		io_hlt();
	}
}