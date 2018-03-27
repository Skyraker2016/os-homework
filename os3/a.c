#include "program_h.h"

#define UP 0
#define DOWN 24
#define LEFT 0
#define RIGHT 79

void _main(){
    int x = 5;
    int y = 20;
    int dirx = 1;
    int diry = 1;
    _prints("What char do  you want to move: ");
    char* cc = _gets();
    int i=0;
    int l=_strlen(cc);
    while(1){
        if (_check_in()){
            return;
        }
        _delay(100);
        x += dirx;
        y += diry;
        if (x>=RIGHT || x<=LEFT){
            dirx = -dirx;
            x += dirx*2;
        }
        if (y>=DOWN || y<=UP){
            diry = -diry;
            y += diry*2;
        }
        char c = cc[i];
        i = (i+1)%l;
        _printc_any(c, x, y);
    }
    return;
}