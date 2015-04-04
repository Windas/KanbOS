void io_hlt(void);

void HariMain(void)
{
	int i;
	char* p;

	for (i = 0xa0000; i <= 0xaffff; i++) {
		p = i;
		*p = 9; 
	}

	for ( ; ; ) {
		io_hlt();
	}
}