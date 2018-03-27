nasm -f bin loader.asm -o loader.bin

nasm -f elf32 os_asm.asm -o os_asm.o
gcc -march=i386 -m32 -mpreferred-stack-boundary=2 -ffreestanding -Wa,-R -c os_c.c -o os_c.o
.\ld.exe -m i386pe -N os_c.o os_asm.o -Ttext 0x1000 -o os.tmp
objcopy -O binary os.tmp os.bin

dd if=loader.bin of=boot.img bs=512 count=1 conv=notrunc
dd if=os.bin of=boot.img bs=512 count=15 seek=1 conv=notrunc

gcc -march=i386 -m32 -mpreferred-stack-boundary=2 -ffreestanding -Wa,-R -c upper.c -o upper.o
.\ld.exe -m i386pe -N upper.o os_asm.o -Ttext 0x0000 -o upper.tmp
objcopy -O binary upper.tmp upper.bin
dd if=upper.bin of=boot.img bs=512 count=16 seek=16 conv=notrunc

gcc -march=i386 -m32 -mpreferred-stack-boundary=2 -ffreestanding -Wa,-R -c a.c -o a.o
.\ld.exe -m i386pe -N a.o os_asm.o -Ttext 0x2000 -o a.tmp
objcopy -O binary a.tmp a.bin
dd if=a.bin of=boot.img bs=512 count=16 seek=32 conv=notrunc


copy .\boot.img d:\bochs-2.6.9



if "%1" == "r"  bochs.exe -qf d:\bochs-2.6.9\bochsrc
if "%1" == "db" 	bochsdbg.exe -qf d:\bochs-2.6.9\bochsrc

