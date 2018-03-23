@echo off
nasm -f bin 3_2_0.asm -o 3_2_0.bin  > amsg.txt
type amsg.txt |find "Error"
type amsg.txt |find "Warn"

nasm -f bin 3_2_1.asm -o 3_2_1.bin  > amsg.txt
type amsg.txt |find "Error"
type amsg.txt |find "Warn"

nasm -f bin 3_2_2.asm -o 3_2_2.bin  > amsg.txt
type amsg.txt |find "Error"
type amsg.txt |find "Warn"

nasm -f bin 3_2_3.asm -o 3_2_3.bin  > amsg.txt
type amsg.txt |find "Error"
type amsg.txt |find "Warn"

nasm -f bin 3_2_4.asm -o 3_2_4.bin  > amsg.txt
type amsg.txt |find "Error"
type amsg.txt |find "Warn"

dd if=3_2_0.bin of=boot.img bs=512 count=1 
dd if=3_2_1.bin of=boot.img bs=512 seek=1 count=2
dd if=3_2_2.bin of=boot.img bs=512 seek=3 count=2
dd if=3_2_3.bin of=boot.img bs=512 seek=5 count=2
dd if=3_2_4.bin of=boot.img bs=512 seek=7 count=2

copy .\boot.img d:\bochs-2.6.9



if "%1" == "r"  bochs.exe -qf d:\bochs-2.6.9\bochsrc
if "%1" == "db" 	bochsdbg.exe -qf d:\bochs-2.6.9\bochsrc