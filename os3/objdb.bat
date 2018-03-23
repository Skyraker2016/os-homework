set name=%1

if "%2" == "o" .\objdump.exe -m i8086 -d %name%.o
if "%2" == "b" .\objdump.exe -m i8086 -D -b binary %name%.bin