#Makefile的变量定义
TOOLPATH = ../z_tools/
MAKE     = $(TOOLPATH)make.exe -r
NASK     = $(TOOLPATH)nask.exe
EDIMG    = $(TOOLPATH)edimg.exe
IMGTOL   = $(TOOLPATH)imgtol.com
COPY     = copy
DEL      = del

# 默认指令

default :
	$(MAKE) img

# 镜像生成依赖

ipl.bin : ipl.nas Makefile
	$(NASK) ipl.nas ipl.bin ipl.lst

kanbos.sys : kanbos.nas Makefile
	$(NASK) kanbos.nas kanbos.sys kanbos.lst

kanbos.img : ipl.bin kanbos.sys Makefile
	$(EDIMG)   imgin:../z_tools/fdimg0at.tek \
		wbinimg src:ipl.bin len:512 from:0 to:0 \
		copy from:kanbos.sys to:@: \
		imgout:kanbos.img
# 指令

img :
	$(MAKE) kanbos.img

run :
	$(MAKE) img
	$(COPY) kanbos.img ..\z_tools\qemu\fdimage0.bin
	$(MAKE) -C ../z_tools/qemu

install :
	$(MAKE) img
	$(IMGTOL) w a: kanbos.img

clean :
	-$(DEL) ipl.bin
	-$(DEL) ipl.lst
	-$(DEL) kanbos.sys
	-$(DEL) kanbos.lst

src_only :
	$(MAKE) clean
	-$(DEL) kanbos.img
