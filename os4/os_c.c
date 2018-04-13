#include "os_h.h"



int _main(){
    init_os();
    _prints_color(wel_msg, 0x0d);    
    help();
    while(1){
        _prints_color(left_open, 0x0b);
        char * str = _gets();
        if (_cmps( str, load_op)){
            _prints(load_msg);
            str = _gets();
            int ind = _str2int(str);
            if (ind==-1 || program_lists[ind].loaded==1){
                continue;
            }
            else{
                _loadp(program_lists[ind]);
                _prints_color( "Success to load Program ", 0x0d);
                _prints_color( program_lists[ind].name, 0x0f);
                _prints_color( " at ", 0x0d);
                _printd(program_lists[ind].sto_add);
                _prints_color( " .\r\n", 0x0d);
                program_lists[ind].loaded = 1;
            }
        }
        else if (_cmps( str, load_all_op)){
            int i=0;
            for (i=0; i<PROGRAM_SIZE; i++){
                if (program_lists[i].loaded!=1){
                    _loadp(program_lists[i]);
                    program_lists[i].loaded = 1;
                }
            }
            _prints_color( "Success to load all Program.\r\n", 0x0d);
        }
        else if ( _cmps(str, help_op)){
            help();
        }
        else if (_cmps( str, run_op)){
            _prints("Please choose which to run: ");
            str = _gets();
            int ind = _str2int(str);
            if (ind==-1 || ind>=PROGRAM_SIZE || program_lists[ind].loaded==0 ){
                _prints_color("ERROR!! Invalid input or Program has not been loaded!\r\n", 0x0c);
                continue;
            }
            else{
                _init();
                _run_program(program_lists[ind].sto_add/0x10000*0x1000, program_lists[ind].sto_add%0x10000);
                _init();
            }
        }
        else if (_cmps( str, list_op)){
            print_table(program_lists);
        }
        else if (_cmps( str, time_op)){
            _show_time();
        }
        else if (_cmps( str, reload_op)){
            _reload();
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


