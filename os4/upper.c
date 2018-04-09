#include "program_h.h"

void _main(){
    _prints("Please input a string: \r\n");
    char * str = _gets();
    int i=0;
    for (; str[i]!=0; i++){
        if (str[i]>='a' && str[i]<='z')
            str[i] += 'A'-'a';
    }
    _prints("Upper: \r\n");
    _prints(str);
    _prints("\r\n");
    _getc();
    return;
}