__asm__(".code16gcc\n");
__asm__("mov $0, %eax\n");
__asm__("mov %ax, %ds\n");
__asm__("mov %ax, %es\n");
__asm__("jmpl $0, $__main\n");

extern void print_s(const char *, int, int);

int y = 0;
const char * wel_msg = "WELCOME TO MY_OS:";
const char * left_open = "~>>";
/*
wel_msg         dw "WELC"
left_open       dw "ome "
                dw "to m"
        ...


*/
void prints(const char *);
int str_len(const char *);

int _main(){
    prints(wel_msg);
    prints(left_open);
    while(1);
    return 0;
}

void prints(const char *s){
    int l = str_len(s);
    print_s(s, l, y);
    y++;
    return;
}

int str_len(const char *s){
    int i=0;
    while(s[i]!=0)
        i++;
    return i;
}
