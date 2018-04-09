#include "program_h.h"

#define UP 0
#define DOWN 24
#define LEFT 0
#define RIGHT 79


    int col_pos_up[12] = { 3, UP+1, 17, UP+1, 31, UP+1, 45, UP+1, 59, UP+1, 73, UP+1};
    int col_pos_dn[10] = { 10, DOWN-1, 24, DOWN-1, 38, DOWN-1, 52, DOWN-1, 66, DOWN-1};
    int row_pos_le[4] = { 3, LEFT+1, 15, LEFT+1};
    int row_pos_ri[4] = { 9, RIGHT-1, 21, RIGHT-1};

void _main(){

    
    _prints("Please input what you want to show: ");
    char *info = _gets();
    int l=_strlen(info);
    info[l] = ' ';
    info[l+1] = ' ';
    info[l+2] = ' ';
    info[l+3] = 0;
    l += 3;

    int color = 1;
    int i=0;
    int sl = 0;
    while(1){
        if (_check_in()){
            return;
        }
        for (i=0; i<6; i++){
            _printc_color_any(info[sl], col_pos_up[i*2], col_pos_up[i*2+1], color);
            col_pos_up[i*2+1] ++;
            if (col_pos_up[i*2+1]>DOWN-1){
                col_pos_up[i*2+1] = UP+1;
            }
            color++;
            if (color >= 16){
                color = 1;
            }
        }
        for (i=0; i<5; i++){
            _printc_color_any(info[sl], col_pos_dn[i*2], col_pos_dn[i*2+1], color);
            col_pos_dn[i*2+1]--;
            if (col_pos_dn[i*2+1]<UP+1){
                col_pos_dn[i*2+1] = DOWN-1;
            }
            color++;
            if (color >= 16){
                color = 1;
            }
        }
       for (i=0; i<2; i++){
            _printc_color_any(info[sl], row_pos_le[i*2+1], row_pos_le[i*2], color);
            row_pos_le[i*2+1]++;
            if (row_pos_le[i*2+1]>RIGHT-1){
                row_pos_le[i*2+1] = LEFT+1;
            }
            color++;
            if (color >= 16){
                color = 1;
            }
        }
        for (i=0; i<2; i++){
            _printc_color_any(info[sl], row_pos_ri[i*2+1], row_pos_ri[i*2], color);
            row_pos_ri[i*2+1]--;
            if (row_pos_ri[i*2+1]<LEFT+1){
                row_pos_ri[i*2+1] = RIGHT-1;
            }
            color++;
            if (color >= 16){
                color = 1;
            }
        }
        
        sl = (sl+1)%l;
        _delay(100);
    }
    return;
}