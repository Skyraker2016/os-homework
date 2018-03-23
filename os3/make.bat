
nasm -f bin loader.asm -o loader.bin > .\log\amsg.txt

nasm -f elf32 os_asm.asm -o os_asm.o > .\log\amsg.txt
gcc -march=i386 -m32 -mpreferred-stack-boundary=2 -ffreestanding -c os_c.c -o os_c.o > .\log\cmsg.txt
ld -m i386pe -N os_c.o os_asm.o -Ttext 0x8100 -Tdata 0x9100 -o os.tmp > .\log\lmsg.txt
objcopy -O binary os.tmp os.bin

dd if=loader.bin of=boot.img bs=512 count=1 conv=notrunc
dd if=os.bin of=boot.img bs=512 count=16 seek=1 conv=notrunc
copy .\boot.img d:\bochs-2.6.9



if "%1" == "r"  bochs.exe -qf d:\bochs-2.6.9\bochsrc
if "%1" == "db" 	bochsdbg.exe -qf d:\bochs-2.6.9\bochsrc

