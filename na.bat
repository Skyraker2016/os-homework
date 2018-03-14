@echo off
set name=%1
nasm -f bin %name%.asm -o %name%.bin  > amsg.txt
type amsg.txt |find "Error"
type amsg.txt |find "Warn"
