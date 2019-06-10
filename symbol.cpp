#include "symbol.hpp"

/* initialize symbol table */
vector<map<string, Identifier> >  symtable_list;
int symbol_inited = 0;
int maxi_id = 0;
/* Create a symbol table. */
void create(){
    symtable_list = vector<map<string, Identifier> >();
    symbol_inited = 1;
}

void push(){
    if(!symbol_inited)
        create();
    symtable_list.push_back(map<string, Identifier>());
}

void pop(){
    if(!symbol_inited)
        create();
    symtable_list.pop_back();
}

int insert(char* name){
    if(!symbol_inited)
        create();
    string std_name(name);
    /* check dup 
        only check the local scope
    */
    if(symtable_list[symtable_list.size()-1].find(std_name)!=symtable_list[symtable_list.size()-1].end()){
        cout << "notnotnotnotnotnotnontot=======================" << endl;
        return -1;
    }/* new id */
    Identifier id;
    id.num = symtable_list[symtable_list.size()-1].size();
    id.name = std_name;
    symtable_list[symtable_list.size()-1][std_name] = id;
    return maxi_id++;
}

int insert(string std_name){
    if(!symbol_inited)
        create();
    /* check dup 
        only check the local scope
    */
    if(symtable_list[symtable_list.size()-1].find(std_name)!=symtable_list[symtable_list.size()-1].end()){
        return -1;
    }/* new id */
    Identifier id;
    // id only on that scope
    id.num = symtable_list[symtable_list.size()-1].size();
    id.name = std_name;
    if(symtable_list.size() == 1)
        id.is_global = true;
    else
        id.is_global = false;
    symtable_list[symtable_list.size()-1][std_name] = id;
    return maxi_id++;
}

int lookup(char* name){
    if(!symbol_inited)
        create();
    string std_name(name);
    for(int i=symtable_list.size()-1;i>=0;--i){
        if(symtable_list[i].find(std_name) != symtable_list[i].end())
            return symtable_list[i].find(std_name)->second.num;
    }
    return -1;
}

int lookup(string std_name){
    if(!symbol_inited)
        create();
    for(int i=symtable_list.size()-1;i>=0;--i){
        if(symtable_list[i].find(std_name) != symtable_list[i].end())
            return symtable_list[i].find(std_name)->second.num;
    }
    return -1;
}


Identifier get_info(string std_name){
    if(!symbol_inited)
        create();
    for(int i=symtable_list.size()-1;i>=0;--i){
        if(symtable_list[i].find(std_name) != symtable_list[i].end())
            return symtable_list[i].find(std_name)->second;
    }
    return Identifier();
}



void set_type(string std_name, int id_type, int val_type){
    if(!symbol_inited)
        create();
    for(int i=symtable_list.size()-1;i>=0;--i){
        if(symtable_list[i].find(std_name) != symtable_list[i].end()){
            symtable_list[i].find(std_name)->second.id_type = id_type;
            symtable_list[i].find(std_name)->second.val_type = val_type;
            return;
        }
    }
}


void set_id_list(string std_name,vector<int>* id_type_list){
    if(!symbol_inited)
        create();
    for(int i=symtable_list.size()-1;i>=0;--i){
        if(symtable_list[i].find(std_name) != symtable_list[i].end()){
            symtable_list[i].find(std_name)->second.data.arg_info = id_type_list;
            return;
        }
    }
}

void dump(){
    if(!symbol_inited)
        create();
    /* only dump the outer layer*/
    cout << "\033[1;33m" << "id\tname\tid_type\tval_type\tscope_level" << "\033[0m" << endl;
    for(int i = symtable_list.size()-1;i>=0;--i){
        for(auto it=symtable_list[i].begin();it!=symtable_list[i].end();it++){
            cout << it->second.num << '\t' << it->first << '\t' << id_names[it->second.id_type] << '\t' << val_names[it->second.val_type] << '\t' << i << endl;
        }
    }
    
}

bool is_calc_able(Identifier a,Identifier b){
    if(a.val_type != b.val_type)
        return false;
    if(a.val_type == val_str || b.val_type == val_str || a.val_type == val_bool || b.val_type == val_bool)
        return false;
    return true;
}

bool is_calc_able(Identifier a){
    if(a.val_type == val_str || a.val_type == val_bool)
        return false;
    return true;
}

bool is_const(Identifier a){
    if(a.id_type == const_type)
        return true;
    return false;
}

void set_para(string std_name,int num){
    if(!symbol_inited)
        create();
    for(int i=symtable_list.size()-1;i>=0;--i){
        if(symtable_list[i].find(std_name) != symtable_list[i].end()){
            symtable_list[i].find(std_name)->second.para_num = num;
            return;
        }
    }
}

void set_val(string std_name, Id_Val val){
    if(!symbol_inited)
        create();
    for(int i=symtable_list.size()-1;i>=0;--i){
        if(symtable_list[i].find(std_name) != symtable_list[i].end()){
            symtable_list[i].find(std_name)->second.val = val;
            return;
        }
    }
}