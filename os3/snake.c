#include "program_h.h"

#define UP 5
#define DOWN 20
#define LEFT 20
#define RIGHT 60

#define DD 0x4de0
#define WW 0x48e0
#define SS 0x50e0
#define AA 0x4be0
// #define DD 'd'
// #define AA 'a'
// #define SS 's'
// #define WW 'w'

int sc[16][41] = {0};
int score = 0;
int sx[200] = {0};
int sy[200] = {0};

void init_screen();
void screen();
void show(int, int);
void food();

void _main(){
    init_screen();
    int op = DD;
    while(1){
  //      _printc_any('Z',5,3);
        screen();
        //_printc_any('A',5,3);
        int tmp = _getc_dontway();
        int xx, yy;
        xx = sx[0];
        yy = sy[0];
//        int flag = 0;
        // _set_gb(4,5);
        // _printd(sx[0]);
        // _printd(sy[0]);

        // else{
        //     _printd(++flag);
        // }
        
        _set_gb(0,12);
        _prints("----");
        _printc(tmp);
        _prints("::");
        _printc(op);
try_again:
        if ((tmp == DD && op != AA )|| (tmp == AA && op == DD)){
            yy = sy[0]+1;
            // _set_gb(2,12);
            // _prints("++++");
            // _printc(tmp);
            // _printc(op);
            tmp = DD;
        }
        else if ((tmp == AA && op != DD) || (tmp == DD && op == AA)){
            yy = sy[0]-1;
            tmp = AA;
        }
        else if ((tmp == WW && op != SS )||( tmp == SS && op == WW)){
            xx = sx[0]-1;
            tmp = WW;
        }
        else if ((tmp == SS && op != WW) || (tmp == WW && op == SS)){
            xx = sx[0]+1;
            tmp = SS;
        }
        else{
            tmp = op;
            goto try_again;
        }
        
        //_printc_any('B',5,3);

        // _set_gb(4,6);
        // _printd(sx[0]);
        // _printd(sy[0]);
        // _set_gb(4,4);
        // _printd(xx);
        // _printd(yy);
        if (sc[xx][yy]==0x70 || sc[xx][yy]==0x50){
            _set_gb(22,14);
            _prints_color(" GAMEOVER! Press any key to leave....  ", 0x74);
            _getc();
            _delay(30);
            return;
        }
        else if (sc[xx][yy]==0x30){
            for (int i=score+2; i>0; i--){
                sx[i] = sx[i-1];
                sy[i] = sy[i-1];
            }            
            sx[0] = xx;
            sy[0] = yy;
            sc[xx][yy] = 0x50;
            score++;
            food();
        }
        else{
            sc[sx[score+1]][sy[score+1]] = 0;
            for (int i=score+1; i>0; i--){
                sx[i] = sx[i-1];
                sy[i] = sy[i-1];
            }            
            sx[0] = xx;
            sy[0] = yy;
            sc[xx][yy] = 0x50;
        }
        _delay(300);
        
        // _printc_any('C',5,3);
        op = tmp;
    }
    return;
}

void init_screen(){
    _prints_color("w s a d to control snake", 0x0b);
    _set_gb(0,3);
    _prints_color("Score: ", 0x0f);
    for (int i=0; i<16; i++){
        for (int j=0; j<41; j++){
            if (i==0 || j==0 || i==15 || j==40){
                sc[i][j] = 0x70;
            }
            else
                sc[i][j] = 0;
        }
    }
    score = 0;
    sx[0] = sx[1] = sy[0] = 3;
    sy[1] = 2;
    sc[sx[0]][sy[0]] = 0x50;
    sc[sx[score+1]][sy[score+1]] = 0x50;
    food();
}

void screen(){
    _set_gb(7,3);
    _printd(score);
    for (int i=0; i<16; i++){
        for (int j=0; j<41; j++){
            show(i,j);
        }
    }
    return;
}

void show(int y, int x){
    x += LEFT+1;
    y += UP+1;
    _printc_color_any(' ', x, y, sc[y-UP-1][x-LEFT-1]);
}

void food(){
    int x = _random();
    int y = _random();
    _set_gb(2,9);
    _printd(x);
    _printd(y);
    x = x%14+1;
    y = y%39+1;
    while(sc[x][y]!=0){
        x = _random()%14+1;
        y = _random()%39+1;
    }
    _set_gb(2,10);
    _printd(x);
    _printd(y);
    sc[x][y] = 0x30;
}