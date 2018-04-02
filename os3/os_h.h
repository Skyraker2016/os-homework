#ifndef _OS_H
#define _OS_H

//Tell GCC
__asm__(".code16gcc\n");
__asm__("mov $0, %eax\n");
__asm__("mov %ax, %ds\n");
__asm__("mov %ax, %es\n");
__asm__("jmpl $0, $__main\n");

#include "lib.h"

typedef struct
{
    int mem_add;
    int sto_add;
    int size;
    char *name;
    int loaded;
} ProgramList;

#define PROGRAM_SIZE 5

ProgramList program_lists[PROGRAM_SIZE] ={
                    {0x4000, 0x10000, 0x2000, "TO UPPER", 0},
                    {0x6000, 0x13000, 0x2000, "ANY STRING", 0},
                    {0x8000, 0x18000, 0x4000, "COLORFUL A", 0},
                    {0xC000, 0x20000, 0x4000, "SNAKE", 0},
                    {0x10000, 0x30000, 0x2000, "ASCII", 0}
                };
const char * wel_msg = "WELCOME TO MY_OS:\r\n";
const char * left_open = "~>> ";
const char * load_op = "-load";
const char * load_msg = "Input the index of your program: ";
const char * list_op = "-list";
const char * time_op = "-time";
const char * run_op = "-run";
const char * load_all_op = "-lall";
const char * help_op = "-help";
const char * reload_op = "-reload";
//const char * page_up = "-up";
//const char * page_down = "-down";

void print_table(ProgramList*);
int _loadp(ProgramList);//load a program
void help();




void print_table(ProgramList *p){
    _prints_color("\r\n|----------------------------------------------------------------------------",0x0e);
    for (int i=0; i<PROGRAM_SIZE; i++){
        _prints_color("\r\n|- ID: ",0x0e);
        _printd(i);
        _prints_color("\tName: ",0x0e);
        _prints(p[i].name);
        _prints_color("\tDisk: ",0x0e);
        _printd(p[i].mem_add);
        _prints_color("\tMemory: ",0x0e);
        _printd(p[i].sto_add);
        _prints_color("\tSize: ",0x0e);
        _printd(p[i].size);
        _prints_color("\tStatus: ", 0x0e);
        if (p[i].loaded == 0){
            _prints("Unloaded");
        }
        else{
            _prints("Loaded");
        }
    }
    
    _prints_color("\r\n|----------------------------------------------------------------------------\r\n",0x0e);
}

int _loadp(ProgramList p){
    int ind = p.mem_add / 512;
    int a = (ind/18)%2;
    int b = (ind%18)+1;
    int c = ind/36;
    int size = p.size/512;
    int offset = p.sto_add%0x10000;
    int seg = p.sto_add/0x10000*0x1000;
    _load_program(a,b,c,size, offset, seg);
    return p.sto_add;
}

void help(){
    _prints_color("\r\nHere is the help of OS: ", 0x0E);
    _prints_color("\r\nOption  ", 0x0D);
    _prints_color("Describe", 0x0D);
    _prints_color("\r\n-help  ", 0x0D);
    _prints_color("show the help of OS", 0x0F);
    _prints_color("\r\n-load  ", 0x0D);
    _prints_color("load a program, by index", 0x0F);
    _prints_color("\r\n-run   ", 0x0D);
    _prints_color("run a loaded program, by index", 0x0F);
    _prints_color("\r\n-list  ", 0x0D);
    _prints_color("list the program table", 0x0F);
    _prints_color("\r\n-time  ", 0x0D);
    _prints_color("show current time", 0x0F);
    _prints_color("\r\n-lall  ", 0x0D);
    _prints_color("load all the program", 0x0F);
    _prints("\r\n");
}






#endif