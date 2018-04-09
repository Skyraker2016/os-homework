#ifndef _LIB_H
#define _LIB_H

#define _CMD_BUFFER_ 64
#define KEYRIGHT 0x4de0
#define KEYUP 0x48e0
#define KEYDOWN 0x50e0
#define KEYLEFT 0x4be0
//function in C
void _prints_any(const char *, int, int);//print string anywhere 
void _prints(const char *);//print string
void _prints_color(const char *, int);
void _printd(int);//print a dec
void _printc_any(const char, int, int);//print char anywhere
void _printc_color_any(const char, int, int, int);
int _strlen(const char *);//get string's length
char* _gets();//input a string
int _cmps(const char *, const char *);//compare 2 strings
int _str2int(const char *);//change string to int
void _init();//init the screen
void _show_time();
int _random();
void int_08H_c();
void int_09H_c();

//function in ASM
extern void _printc(const char);//print a char
extern int _getc();//get a char
extern int _getc_dontway();//get a char, or go away
extern char _printc_color(const char, int);//print a char with color
extern void _reload();
//extern void _uproll(int); //up roll the screen
//extern void _downroll(int); //up roll the screen
extern void _load_program(int,int,int,int, int, int);//load a program
extern void _run_program(int, int);//run a program
extern void _clc();//clear screen
extern void _set_gb(int, int);//set gb position
extern int _get_gb();
extern int _check_in();
extern void _delay(int);
extern int _get_time();
extern int _get_date();
extern void init_int_time();
extern void init_int_keyboard();

//var
char _buffer[_CMD_BUFFER_];
char *_wrong_msg = "Invalid input, check again...\r\n";
int int_time_count = 0;
int int_keyboard_count = 0;
char *int_time_char = "|/-\\*";

void int_08H_c(){
    int_time_count = (int_time_count+1)%300;
    _printc_any(int_time_char[int_time_count/60%5],77, 23);
    _printc_any(int_time_count/30+'0',75, 23);
    return;
}

void int_09H_c(){
    int_keyboard_count = (int_keyboard_count+1)%3;
    _prints_any("     ",74,20);
    _prints_any("     ",74,21);
    _prints_any("     ",74,22);
    _prints_any("OUCH!",74,20+int_keyboard_count);
    return;
}

void _init(){
    _clc();
    _set_gb( 0, 0);
}

void _prints(const char *s){
    int l = _strlen(s);
    int i = 0;
    for (; i<l; i++){
        _printc(s[i]);
    } 
    return;
}

void _prints_any(const char *s, int x, int y){
    int l = _strlen(s);
    if (x+l>=80){
        return;
    }
    int tmp = _get_gb();
    int ox = tmp/256%256;
    int oy = tmp%256;
    _set_gb(x,y);
    for (int i=0; i<l; i++){
        _printc(s[i]);
    }    
    _set_gb(ox,oy);
}

void _printc_any(const char c, int x, int y){
    int tmp = _get_gb();
    int ox = tmp/256%256;
    int oy = tmp%256;
    _set_gb(x,y);
    _printc(c);
    _set_gb(ox,oy);
}

void _printd(int d){
    char res[15];
    int i = 0;
    if (d==0){
        _printc('0');
    }
    while(d!=0){
        res[i] = d%10+'0';
        d /= 10;
        i++;
    }
    for (i--; i>=0; i--){
        _printc(res[i]);
    } 
}

char* _gets(){
    int post = 0;
    while(1){
        char tmp = _getc();

        if (tmp == '\r'){
            _buffer[post] = 0;
            _prints("\r\n");
            break;
        }
        else if (post>0 && tmp == '\b'){
            post--;
            _prints("\b \b");
            _buffer[post] = 0;
        }
        else if (tmp != '\b'){
            _printc(tmp);
            _buffer[post] = tmp;
            post++;
        }
    }
    return _buffer;
}

int _strlen(const char *s){
    int i=0;
    while(s[i]!=0)
        i++;
    return i;
}

int _cmps(const char *a, const char *b){
    int i=0;
    while(a[i]!=0 && b[i]!=0){
        if (a[i]!=b[i])
            return 0;
        i++;
    }
    if (a[i]==0 && b[i]==0)
        return 1;
    return 0;
}

int _str2int(const char *s){
    int res = 0;
    int i = 0;
    if (s[0]==0){
        _prints(_wrong_msg);
        return -1;
    }
        
    if (s[0]=='0' && s[1]=='x'){
        i = 2;
        for (; s[i]!=0; i++){
            if (s[i]>='0' && s[i]<='9')
                res = res*16+s[i]-'0';
            else if (s[i]>='a' && s[i]<='f')
                res = res*16+s[i]-'a'+10;
            else if (s[i]>='A' && s[i]<='F')
                res = res*16+s[i]-'A'+10;
            else{

            }
        }        
    }
    else{
        for (; s[i]!=0; i++){
            if (s[i]>='0' && s[i]<='9')
                res = res*10+s[i]-'0';
            else{
                _prints(_wrong_msg);
                return -1;
            }
        }
    }
   // _printd(res);
    return res;
}

void _printc_color_any(const char c, int x, int y, int color){
    int tmp = _get_gb();
    int ox = tmp/256%256;
    int oy = tmp%256;
    _set_gb(x,y);
    _printc_color(c, color);
    _set_gb(ox,oy);
}

void _prints_color(const char *s, int color){
    int l = _strlen(s);
    int i = 0;
    int tmp;
    for (; i<l; i++){
        if ( s[i] =='\n' || s[i] == '\t' || s[i]=='\b'){
            _printc(s[i]);
        }
        else if (s[i]=='\r'){
            _printc(s[i]);//????????????
        }
        else{
            tmp = _get_gb();
            _set_gb(tmp%256, tmp/256%256);
            _printc_color(s[i], color);
            _set_gb(tmp%256+1, tmp/256%256);
        }
    } 
    return;
}

void _show_time(){
    int t = _get_time();
    int d = _get_date();
    int year = d/0x10000;
    year = year%0x10 + year/0x10%0x10*10 + year/0x100%0x10*100 + year/0x1000%0x10*1000;
    int month = d%0x10000/0x100;
    month = month%0x10 + month/0x10%0x10*10;
    int day = d%0x100;
    day = day%0x10 + day/0x10%0x10*10;
    int hour = t/0x1000000;
    hour = hour%0x10 + hour/0x10%0x10*10;
    int minute = t/0x10000%0x100;
    minute = minute%0x10 + minute/0x10%0x10*10;
    int second = t/0x100%0x100;
    second = second%0x10 + second/0x10%0x10*10;
    _printd(year);
    _prints("-");
    _printd(month);
    _prints("-");
    _printd(day);
    _prints(" ");
    _printd(hour);
    _prints(":");
    _printd(minute);
    _prints(":");
    _printd(second);
    _prints("\r\n");
}

int _random(){
    return _get_time();
}

#endif 