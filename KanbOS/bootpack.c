void KanbMain(void)
{

//开始引入C语言，由于C语言中没有直接的CPU待机指令(HLT)，因此这里就直接无限循环了
fin:
	goto fin;
	
}