@echo off
set name=%1
nasm -f bin %name%.asm -o %name%.bin  > amsg.txt
type amsg.txt |find "Error"
type amsg.txt |find "Warn"
if "%3" == "b" dd if=%name%.bin of=boot.img bs=512 count=1 conv=notrunc
if "%3" == "p" dd if=%name%.bin of=program.img bs=512 count=2 conv=notrunc
if "%3" == "b" copy .\boot.img d:\bochs-2.6.9
if "%3" == "p" copy .\program.img d:\bochs-2.6.9


if "%2" == "r"  bochs.exe -qf d:\bochs-2.6.9\bochsrc
if "%2" == "db" 	bochsdbg.exe -qf d:\bochs-2.6.9\bochsrc