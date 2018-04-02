#include "program_h.h"


void _main(){
    _prints("Input:\r\n");
    int a = _getc();
    _printc(a);
    _prints("\r\nASCII:\r\n");
    _printd(a/0x100);
    _prints(":");
    _printd(a%0x100);
    _prints("\r\nPress any key to leave...\r\n");
    _getc();
    return;
}