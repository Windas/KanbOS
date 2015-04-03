# KanbOS
-------------------
####A self-make operating system with the book called *30 days to build OS ourselves*

####Giving us a way to make our own OS within this book, I also push tools given by the author so you can run it directly using bat files in directory KanbOS

####I will push some new attributes after finishing reading this book. This res just a copy of my codes

##How to run
-------------------
1. Clone those source code above first.
2. `cd` to the KanbOS directory in tolset folder.
3. Open *!cons_nt.bat* file to run console.
4. Input `make run` and wait a moment.

##Log
-------------------
**Update 1st day**: complete build an easy 'OS' called helloos using machine code

**Update 2nd day**: try to rebuild the helloos within an more readable 8086 assembly lang, also learn to use makefile to compile the codes.

**Update 3rd day**: this time we make a real IPL to boot our OS from disk.
- The first demo is about the way to boot program from disk using INT 0x13
- The second demo is about how to handle error when reading disk
- The third demo is about to read until 18th section. All contents will be put into 0x8200 to 0xa3ff
- Now we reach the fourth demo, which still load data on the disk. This time we try to load until 10 cylinders both sides. I add some messages to tell us whether loaded successfully
- This demo add another .nas file which exactly is the real OS. We just load it into DRAM but not run it.
- We are going to the sixth demo, which contain a real OS this time. The sys file call a graphic BIOS INT to show a total black display
- The last demo here, containing *naskfunc.nas* file as to complete HLT function adding to *bootpack.c*.
- This demo is the one which add the first .c file to complete the OS. Also chage into 32bit mode.
- The last demo here, contain *naskfunc.nas* file to provide a HLT function adding to *bootpack.c*. 

**Update 4th day**: about how to use Clang and draw something onto our monitor.
