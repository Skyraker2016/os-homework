@echo off
::loader
nasm -f bin loader.asm -o loader.bin
dd if=loader.bin of=boot.img bs=512 count=1 conv=notrunc
del loader.bin

::os
nasm -f elf32 os_asm.asm -o os_asm.o
gcc -march=i386 -m32 -mpreferred-stack-boundary=2 -ffreestanding -Wa,-R -c os_c.c -o os_c.o
.\ld.exe -m i386pe -N os_c.o os_asm.o -Ttext 0x1000 -o os.tmp
objcopy -O binary os.tmp os.bin
dd if=os.bin of=boot.img bs=512 count=31 seek=1 conv=notrunc
del os.bin
del os.tmp
del os_c.o

::UPPER
set programname=upper
gcc -march=i386 -m32 -mpreferred-stack-boundary=2 -ffreestanding -Wa,-R -c %programname%.c -o %programname%.o
.\ld.exe -m i386pe -N %programname%.o os_asm.o -Ttext 0x0000 -o %programname%.tmp
objcopy -O binary %programname%.tmp %programname%.bin
dd if=%programname%.bin of=boot.img bs=512 count=32 seek=32 conv=notrunc
del %programname%.tmp
del %programname%.bin
del %programname%.o

::A JUMP
set programname=a
gcc -march=i386 -m32 -mpreferred-stack-boundary=2 -ffreestanding -Wa,-R -c %programname%.c -o %programname%.o
.\ld.exe -m i386pe -N %programname%.o os_asm.o -Ttext 0x8000 -o %programname%.tmp
objcopy -O binary %programname%.tmp %programname%.bin
dd if=%programname%.bin of=boot.img bs=512 count=32 seek=64 conv=notrunc
del %programname%.tmp
del %programname%.bin
del %programname%.o

::COLORFUL STRING
set programname=colorful_string
gcc -march=i386 -m32 -mpreferred-stack-boundary=2 -ffreestanding -c %programname%.c -o %programname%.o
.\ld.exe -m i386pe -N %programname%.o os_asm.o -Ttext 0x0000 -o %programname%.tmp
objcopy -O binary %programname%.tmp %programname%.bin
dd if=%programname%.bin of=boot.img bs=512 count=32 seek=96 conv=notrunc
del %programname%.tmp
del %programname%.bin
del %programname%.o

::SNAKE
set programname=snake
gcc -march=i386 -m32 -mpreferred-stack-boundary=2 -ffreestanding -Wa,-R -c %programname%.c -o %programname%.o
.\ld.exe -m i386pe -N %programname%.o os_asm.o -Ttext 0x8000 -o %programname%.tmp
objcopy -O binary %programname%.tmp %programname%.bin
dd if=%programname%.bin of=boot.img bs=512 count=32 seek=128 conv=notrunc
del %programname%.tmp
del %programname%.bin
del %programname%.o

::ASCII
set programname=ascii
gcc -march=i386 -m32 -mpreferred-stack-boundary=2 -ffreestanding -Wa,-R -c %programname%.c -o %programname%.o
.\ld.exe -m i386pe -N %programname%.o os_asm.o -Ttext 0x0000 -o %programname%.tmp
objcopy -O binary %programname%.tmp %programname%.bin
dd if=%programname%.bin of=boot.img bs=512 count=32 seek=160 conv=notrunc
del %programname%.tmp
del %programname%.bin
del %programname%.o

del os_asm.o

::copy to bochs
copy .\boot.img d:\bochs-2.6.9

::run or debug
if "%1" == "r"  bochs.exe -qf d:\bochs-2.6.9\bochsrc
if "%1" == "db" 	bochsdbg.exe -qf d:\bochs-2.6.9\bochsrc

