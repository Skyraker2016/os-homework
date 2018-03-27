#include "os_h.h"

typedef struct
{
    int mem_add;
    int sto_add;
    int size;
    char *name;
} ProgramList;



ProgramList program_lists[3] ={
                    {0x2000, 0x10000, 0x2000, " TO UPPER "},
                    {0x4000, 0x12000, 0x2000, "ANY STRING"},
                    {0x6000, 0x14000, 0x2000, "COLORFUL A"}
                };
const char * wel_msg = "WELCOME TO MY_OS:\r\n";
const char * left_open = "~>> ";
const char * load_op = "-load";
const char * load_msg = "Input the index of your program: ";
const char * list_op = "-list";
//const char * page_up = "-up";
//const char * page_down = "-down";

void print_table(ProgramList*);
int _loadp(ProgramList);//load a program

int _main(){
    _init();
    _prints_color(wel_msg, 0x0d);
    while(1){
        _prints_color(left_open, 0x0b);
        char * str = _gets();
        if (_cmps( str, load_op)){
            _prints(load_msg);
            str = _gets();
            int ind = _str2int(str);
            if (ind==-1){
                continue;
            }
            else{
                int add = _loadp(program_lists[ind]);
                _clc();
                _run_program(add/0x10000*0x1000, add%0x10000);
            }
            _init();
        }
        else if (_cmps( str, list_op)){
            print_table(program_lists);
        }
//        else if (_cmps( str, page_up)){
//            _uproll(5);
//        }
//       else if (_cmps( str, page_down)){
//            _downroll(5);
//        }
    }
    return 0;
}




void print_table(ProgramList *p){
    _prints("\r\n|-------------------------------------|");
    _prints("\r\n|  Name      | Memory| Position | Size |");
    for (int i=0; i<3; i++){
        _prints("\r\n| ");
        _prints(p[i].name);
        _prints("\t| ");
        _printd(p[i].mem_add);
        _prints("\t| ");
        _printd(p[i].sto_add);
        _prints("\t| ");
        _printd(p[i].size);
        _prints("\t|");
    }
    
    _prints("\r\n|------------------------------------|\r\n");
}

int _loadp(ProgramList p){
    int ind = p.mem_add / 512;
    int a = (ind/18)%2;
    int b = (ind%18)+1;
    int size = 16;
    int offset = p.sto_add%0x10000;
    int seg = p.sto_add/0x10000*0x1000;
    _load_program(a,b,size, offset, seg);
    return p.sto_add;
}