void io_hlt(void);

void HariMain(void)
{

	char* p;

	for (p = 0xa0000; p <= 0xaffff; p++) {
		*p = 9; 
	}

	for ( ; ; ) {
		io_hlt();
	}
}