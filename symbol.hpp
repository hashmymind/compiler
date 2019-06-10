#pragma once
#include <map>
#include <stack>
#include <vector>
#include <string>
#include <iostream>
#include <cstdio>
using namespace std;
void create();
int lookup(char* name);
int lookup(string);
int insert(char* name);
int insert(string);
void dump();
void push();
void pop();
const string id_names[] = {"void_type","var_type","const_type","proc_type","modu_type","para_type"};
const string val_names[] = {"val_void","val_int","val_real","val_bool","val_str"};
enum IdType{
    void_type = 0,
    var_type = 1,
    const_type =2,
    proc_type = 3,
    modu_type = 4,
    para_type = 5,
    arr_type = 6
};

enum ValType{
    val_void = 0,
    val_int = 1,
    val_real = 2,
    val_bool = 3,
    val_str = 4
};

union Id_Data{
    vector<int>* arg_info;
};

union Id_Val{
    bool bval;
    int ival;
    float fval;
    string* sval;
};

struct Identifier{
    int id_type;
    int val_type;
    int num;
    string name;
    Id_Data data;
    Id_Val val;
    bool is_global;
    int para_num;
};


bool is_calc_able(Identifier);
bool is_calc_able(Identifier,Identifier);
bool is_cosnt(Identifier);
void set_type(string,int,int);
void set_id_list(string,vector<int>*);
void set_val(string,Id_Val);
void set_para(string,int);
Identifier get_info(string);