#include "code.hpp"

int label_count = 0;
vector<string> label_stack;

string get_label(){
    return "L_"+to_string(label_count++);
}

void genNOP(){
    out << "nop" << endl;
}

void genModuleStart(string moduleName){
    ModuleName = moduleName;
    out << "class " << moduleName << endl;
    out << "{" << endl;
}

void genModuleEnd(){
    out << "}" << endl;
}

void genMainBegin(){
    out << "method public static void main(java.lang.String[])" << endl;
    out << "max_stack 15" << endl;
    out << "max_locals 15" << endl;
    out << "{" << endl;
}
void genMainEnd(){
    out << "}" << endl;
}

void genVar(Identifier id){
    // only consider integer
    if(id.is_global){
        out << "field static int " << id.name << endl;
    }else{
        // to be clear
    }
}

void genGetVar(Identifier id){
    if(id.is_global){
        out << "getstatic int " << ModuleName << "." << id.name << endl;
    }
    else{
        out << "iload " << id.num << endl;
    }
}

void genGetConst(Identifier id){
    if(id.val_type == val_str){
        // don't know if it need ""
        out << "ldc " << *id.val.sval << endl;
    }else if(id.val_type == val_int){
        out << "sipush " << id.val.ival << endl;
    }
    else if(id.val_type == val_bool){
        if(id.val.bval)
            out << "iconst_1" << endl;
        else
            out << "iconst_0" << endl;
    }

}

void genCalcOP(char op){
    switch(op){
        case '+':
        out << "iadd" << endl;
        break;
        case '-':
        out << "isub" << endl;
        break;
        case '*':
        out << "imul" << endl;
        break;
        case '/':
        out << "idiv" << endl;
        break;
        case 'm':
        out << "ineg" << endl;
        break;
        case '~':
        out << "ldc 1\n" << "ixor" << endl;
        break;
        case '|':
        out << "ior" << endl;
        break;
        case '&':
        out << "iand" << endl;
        break;
    }
}

void genCondOP(string op){
    string l1 = get_label();
    string l2 = get_label();
    out << "isub" << endl;
    if(op == "<")
        out << "iflt " << l1 << endl;
    else if(op == "<=")
        out << "ifle " << l1 << endl;
    else if(op == ">")
        out << "ifgt " << l1 << endl;
    else if(op == ">=")
        out << "ifge " << l1 << endl;
    else if(op == "=")
        out << "ifeq " << l1 << endl;
    else if(op == "<>")
        out << "ifne " << l1 << endl;
    out << "iconst_0" << endl;
    out << "goto " << l2 << endl;
    out << l1 << ":" << endl;
    out << "iconst_1" << endl;
    out << l2 << ":" << endl;
}


void genAssign(Identifier id){
    // only consider integer
    if(id.is_global)
        out << "putstatic int " << ModuleName << "." << id.name << endl;
    else
        out << "istore " << id.num << endl;
}

void genPrintStart(){
    out << "getstatic java.io.PrintStream java.lang.System.out" << endl;
}

void genPrint(int val_type){
    if(val_type == val_str)
        out << "invokevirtual void java.io.PrintStream.print(java.lang.String)" << endl;
    else if(val_type == val_int)
        out << "invokevirtual void java.io.PrintStream.print(int)" << endl;
}

void genPrintln(int val_type){
    if(val_type == val_str)
        out << "invokevirtual void java.io.PrintStream.println(java.lang.String)" << endl;
    else if(val_type == val_int)
        out << "invokevirtual void java.io.PrintStream.println(int)" << endl;
}

void genIfSec(){
    string l_else = get_label();
    string l_exit = get_label();
    label_stack.push_back(l_exit);
    label_stack.push_back(l_else);
    out << "ifeq " << *(label_stack.end()-1) << endl;
}

void genIfSecEnd(){
    out << "goto " << *(label_stack.end()-2) << endl;
}

void genIfEnd(){
    out << *(label_stack.end()-2) << ":" << endl;
    // pop l_else and l_exit
    label_stack.pop_back();
    label_stack.pop_back();
}

void genElseSec(){
    out << *(label_stack.end()-1) << ":" << endl;
}

void genLoopStart(){
    string l_loopStart = get_label();
    string l_loopEnd = get_label();
    label_stack.push_back(l_loopStart);
    label_stack.push_back(l_loopEnd);
    out << l_loopStart << ":" << endl;
}

void genLoopBodyStart(){
    out << "ifeq " << *(label_stack.end()-1) << endl;
}

void genLoopEnd(){
    out << "goto " << *(label_stack.end()-2) << endl;
    out << *(label_stack.end()-1) << ":" << endl;
}

void genProcStart(Identifier id){
    // only consider int
    out << "method public static int " << id.name << "(";
    if(id.data.arg_info != nullptr){
        for(int i=0;i< id.data.arg_info->size();++i){
            if(i)
                out << ", ";
            out << "int";
        }
    }
    out << ")" << endl;
    out << "max_stack 15" << endl;
    out << "max_locals 15" << endl;
    out << "{" << endl;
}

void genProcEnd(){
    out << "}" << endl;
}

void genRet(bool t){
    if(t)
        out << "ireturn" << endl;
    else
        out << "return" << endl;
}

void genProcInvo(Identifier id){
    out << "invokestatic int " << ModuleName << "." << id.name << "(";
    for(int i=0;i< (id.data.arg_info->size());++i){
        if(i)
            out << ", ";
        out << "int";
    }
    out << ")" << endl;
}