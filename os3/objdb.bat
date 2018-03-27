set name=%1

if "%2" == "o" objdump -m i8086 -masm=intel -d %name%.o
if "%2" == "b" objdump -m i8086 -D -b binary %name%.bin