#ifndef _PROGRAM_H
#define _PROGRAM_H

//Tell GCC
__asm__(".code16gcc\n");
__asm__("pushw %ds;");
__asm__("pushw %es;");
__asm__("mov %cs, %ax\n");
__asm__("mov %ax, %ds\n");
__asm__("mov %ax, %es\n");
__asm__("call __main\n");
__asm__("popw %es;");
__asm__("popw %ds;");
__asm__("lret\n");


#include "lib.h"

#endif