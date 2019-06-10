%{
    #include <iostream>
    #include <string>
    #include <vector>
    #include <fstream>
    #include "symbol.hpp"
    #include "code.hpp"
    using namespace std;
    /*#define Trace(a) cout << "\033[1;32m" << lineCount+1 << ": "  << a << "\033[0m" << endl; */
    #define Trace(a) ;
    extern "C"
    {
        extern int yylex();
        extern int lineCount;
        void yyerror(const char *s);
    }
    #define CHECK_BiOP(a,b,c) ({\
        if(!is_calc_able(*a,*b)) yyerror("[ERROR]Not calcuable!");\
        Identifier* info = new Identifier();\
        info->val_type = a->val_type;\
        if(a->id_type == const_type && b->id_type == const_type)\
            info->id_type = const_type;\
        else\
            info->id_type = var_type;\
        c = info;\
    })
    vector<string> id_name_list;
    vector<int>* id_type_list;
    vector<int>* invo_type_list;
    vector<int> func_return_stack;
    vector<string> func_name_stack;
    ofstream out;
    string ModuleName;
%}
/* tokens */
%union {
  int int_val;
  float real_val;
  bool bool_val;
  std::string* string_val;
  struct Identifier* id_info;
}
// operator
%token LET BET NE AND OR ASS
// keyword
%token _BEGIN END MODULE PROCEDURE IF THEN ELSE WHILE DO VAR CONST ARRAY OF PRINT PRINTLN _RETURN READ CONTINUE BREAK
// types
%token INT_TYPE REAL_TYPE STR_TYPE BOOL_TYPE CONST_REAL
// other
%token <string_val> ID CONST_STR
%token <int_val> CONST_INT
%token <bool_val> CONST_BOOL
%type <id_info> expr func_invo arr_item const_val
%type <int_val> type opt_type

// priority
%left OR
%left AND
%left '<' LET '=' BET '>' NE
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

%%
program: MODULE ID
{   
    push();
    if(insert(*$2)==-1) yyerror("[Error]Redefine symbol in same scope");
    set_type(*$2,modu_type,val_void);

    genModuleStart(*$2);
} opt_vcs opt_procs _BEGIN
{
    genMainBegin();
} opt_stmts END ID '.'
{
    /* check ID */
    if(*$2!= *$10)yyerror("[Error]Moudle id  dosn't consist");
    /* set type */
    Trace("Derived program");
    cout << "\033[1;35m" << "** program completed ** generate a.jasm" << "\033[0m" << endl;
    pop();

    // main need a return
    genRet(false);
    genMainEnd();
    genModuleEnd();
};
procedure: PROCEDURE ID 
{
    if(insert(*$2)==-1) yyerror("[Error]Redefine symbol in same scope");
    push();
} '(' formal_args ')' opt_type
{
    set_id_list(*$2,id_type_list);
    id_type_list = nullptr;
    func_return_stack.push_back($7);
    id_name_list.clear();
    /* set type */
    set_type(*$2,proc_type,$7);
    Identifier info = get_info(*$2);
    genProcStart(info);
} opt_vcs _BEGIN opt_stmts END ID ';'
{
    /* check ID */
    if(*$2!= *$13) yyerror("[Error]Func id  dosn't consist");
    Trace("Derived procedure with formal arguments");
    /* pop return flag */
    func_return_stack.pop_back();
    /* pop symbol table */
    pop();

    /* void func */
    Identifier info = get_info(*$2);
    if(info.val_type == void_type)
        genRet(false);
    genProcEnd();
}
| PROCEDURE ID
{
    if(insert(*$2)==-1) yyerror("[Error]Redefine symbol in same scope");
    /* push symbol table */
    push();
    Identifier info = get_info(*$2);
    genProcStart(info);
} ':' type
{
    set_type(*$2,proc_type,$5);
    func_return_stack.push_back($5);
}  opt_vcs _BEGIN opt_stmts END ID ';' 
{
    /* check ID */
    if(*$2 != *$11) yyerror("[Error]Func id  dosn't consist");
    Trace("Derived procedure without formal arguments");
    /* pop return flag */
    func_return_stack.pop_back();
    /* pop symbol table */
    pop();

    genProcEnd();
}
| PROCEDURE ID
{
    if(insert(*$2)==-1) yyerror("[Error]Redefine symbol in same scope");
    /* push symbol table */
    push();
    Identifier info = get_info(*$2);
    genProcStart(info);
} opt_vcs _BEGIN
{
    set_type(*$2,proc_type,val_void);
    func_return_stack.push_back(void_type);
} opt_stmts END ID ';' 
{
    /* check ID */
    if(*$2 != *$9) yyerror("[Error]Func id  dosn't consist");
    
    Trace("Derived procedure without formal arguments");
    /* pop return flag */
    func_return_stack.pop_back();
    /* pop symbol table */
    pop();

    genRet(false);
    genProcEnd();
}
;
opt_type: ':' type
{
    $$ = $2;
}
| 
{
    $$ = void_type;
};

stmt: var_assign
{
    Trace("stmt <- var_assign");
}
| arr_assign
{
    Trace("stmt <- arr_assign");
}
| cond
{
    Trace("stmt <- cond");
}
| loop
{
    Trace("stmt <- loop");
}
| command
{
    Trace("stmt <- command");
}
| expr
{
    Trace("stmt <- expr");
}
| proc_invo
{

};
expr: '(' expr ')'
{
    Trace("( expr ) <- expr");
    $$ = $2;
}
| '-' expr %prec UMINUS
{
    Trace("- expr");
    /* check if calc able */
    if(!is_calc_able(*$2)) yyerror("[Error]Not calcuable!");
    $$ = $2;

    genCalcOP('m');
}
| expr '+' expr
{
    Trace("expr <- expr + expr");
    /* check if calc able and return */
    CHECK_BiOP($1,$3,$$);
    $$ = $1;

    genCalcOP('+');
}
| expr '-' expr
{
    Trace("expr <- expr - expr");
    /* check if calc able and return */
    CHECK_BiOP($1,$3,$$);
    $$ = $1;

    genCalcOP('-');
}
| expr '*' expr
{
    Trace("expr <- expr * expr");
    /* check if calc able and return */
    CHECK_BiOP($1,$3,$$);
    $$ = $1;

    genCalcOP('*');
}
| expr '/' expr
{
    Trace("expr <- expr / expr");
    /* check if calc able and return */
    CHECK_BiOP($1,$3,$$);
    $$ = $1;

    genCalcOP('/');
}
| expr '>' expr
{
    Trace("expr <- expr > expr");
    /* check if calc able and return */
    CHECK_BiOP($1,$3,$$);
    Identifier* info = new Identifier();
    info->val_type = val_bool;
    $$ = info;

    genCondOP(">");
}
| expr '<' expr
{
    Trace("expr <- expr < expr");
    /* check if calc able and return */
    CHECK_BiOP($1,$3,$$);
    Identifier* info = new Identifier();
    info->val_type = val_bool;
    $$ = info;

    genCondOP("<");
}
| expr '=' expr
{
    Trace("expr <- expr = expr");
    /* check */
    if($1->val_type != val_void) yyerror("[Error]Can not compare different type");
    Identifier* info = new Identifier();
    info->val_type = val_bool;
    if($1->id_type == const_type && $3->id_type == const_type)
        info->id_type = const_type;
    else
        info->id_type = var_type;
    $$ = info;

    genCondOP("=");
}
| expr BET expr
{
    Trace("expr <- expr >= expr");
    /* check if calc able and return */
    CHECK_BiOP($1,$3,$$);
    Identifier* info = new Identifier();
    info->val_type = val_bool;
    $$ = info;

    genCondOP(">=");
}
| expr LET expr
{
    Trace("expr <- expr <= expr");
    /* check if calc able and return */
    CHECK_BiOP($1,$3,$$);
    Identifier* info = new Identifier();
    info->val_type = val_bool;
    $$ = info;

    genCondOP("<=");
}
| expr NE expr
{
    Trace("expr <- expr <> expr");
    /* check */
    if($1->val_type != $3->val_type || $1->val_type == val_void || $3->val_type == val_void) yyerror("Error Can not compare different type");
    Identifier* info = new Identifier();
    info->val_type = val_bool;
    if($1->id_type == const_type && $3->id_type == const_type)
        info->id_type = const_type;
    else
        info->id_type = var_type;
    $$ = info;

    genCondOP("<>");
}
| expr AND expr
{
    Trace("expr <- expr && expr");
    /* check if it is bool */
    if($1->val_type != $3->val_type || $1->val_type == val_void || $3->val_type == val_void) yyerror("Error Can not compare different type");
    Identifier* info = new Identifier();
    info->val_type = val_bool;
    if($1->id_type == const_type && $3->id_type == const_type)
        info->id_type = const_type;
    else
        info->id_type = var_type;
    $$ = info;

    genCalcOP('&');
}
| expr OR expr
{
    Trace("expr <- expr || expr");
    /* check if it is bool */
    if($1->val_type != $3->val_type || $1->val_type == val_void || $3->val_type == val_void) yyerror("Error Can not compare different type");
    Identifier* info = new Identifier();
    info->val_type = val_bool;
    if($1->id_type == const_type && $3->id_type == const_type)
        info->id_type = const_type;
    else
        info->id_type = var_type;
    $$ = info;

    genCalcOP('|');
}
| '~' expr
{
    Trace("expr <- ~expr");
    /* check if it is bool */
    if($2->val_type != val_bool) yyerror("[Error]Only bool can do logical operation");
    Identifier* info = new Identifier();
    info->val_type = val_bool;
    info->id_type = $2->id_type;
    $$ = info;

    genCalcOP('~');
}
| ID
{
    Trace("expr <- ID");
    /* check exist */
    if(lookup(*$1)==-1)yyerror("[Error]Undefined symbol");
    Identifier* info = new Identifier(get_info(*$1));
    $$ = info;

    if(info->id_type == var_type || info->id_type == para_type)
        genGetVar(*info);
    else if(info->id_type == const_type)
        genGetConst(*info);
}
| arr_item
{
    Trace("expr <- arr_item");
    $$ = $1;
}
| CONST_INT
{
    Trace("expr <- const_int");
    Identifier* info = new Identifier();
    info->id_type = const_type;
    info->val_type = val_int;
    info->val.ival = $1;
    $$ = info;

    genGetConst(*info);
}
| CONST_REAL
{
    Trace("expr <- const_real");
    Identifier* info = new Identifier();
    info->id_type = const_type;
    info->val_type = val_real;
    $$ = info;
}
| CONST_STR
{
    Trace("expr <- const_str");
    Identifier* info = new Identifier();
    info->id_type = const_type;
    info->val_type = val_str;
    info->val.sval = $1;
    $$ = info;

    genGetConst(*info);
}
| CONST_BOOL
{
    Trace("expr <- const_bool");
    Identifier* info = new Identifier();
    info->id_type = const_type;
    info->val_type = val_bool;
    info->val.bval = $1;
    $$ = info;

    genGetConst(*info);
}
| func_invo
{
    /* check exist */
    if(lookup($1->name)==-1)yyerror("Not defined func");
    Identifier* info = new Identifier(get_info($1->name));
    $$ = info;
};
cond: IF '(' expr ')' THEN
{
    genIfSec();
} opt_stmts
{
    genIfSecEnd();
}opt_else END ';'
{
    Trace("if statement without else");
    genIfEnd();
};

opt_else: ELSE {
    genElseSec();
} opt_stmts
| {

};

loop: WHILE
{
    genLoopStart();
} '(' expr ')'
{
    genLoopBodyStart();
} DO opt_loop_stmts END ';'
{
    Trace("Derived loop");
    genLoopEnd();
};
opt_loop_stmts: opt_loop_stmts stmt
{

}
| opt_loop_stmts BREAK
{
}
| opt_loop_stmts CONTINUE
{

}
|
{

};
opt_vcs:opt_vcs var_def  
{
    Trace("optional variable and const define A");
}
| opt_vcs const_def  
{
    Trace("optional variable and const define B");
}
| opt_vcs arr_def  
{
    Trace("optional variable and const define C");
}
|
{};
var_def: VAR var_def_cont
{
    Trace("Derived variable define");
};
var_def_cont: ids ':' type ';'
{
    /* assign type */
    for(int i=0;i<id_name_list.size();++i){
        if(insert(id_name_list[i])==-1) yyerror("[Error]Redefine symbol in same scope");
        set_type(id_name_list[i],var_type,$3);
        Identifier info = Identifier(get_info(id_name_list[i]));
        genVar(info);
    }
    id_name_list.clear();
    
}
| arr_def
{

}
| var_def_cont var_def_cont
{

}
|
{

};

const_val:CONST_INT
{
    Trace("expr <- const_int");
    Identifier* info = new Identifier();
    info->id_type = const_type;
    info->val_type = val_int;
    info->val.ival = $1;
    $$ = info;
}
| CONST_REAL
{
    Trace("expr <- const_real");
    Identifier* info = new Identifier();
    info->id_type = const_type;
    info->val_type = val_real;
    $$ = info;
}
| CONST_STR
{
    Trace("expr <- const_str");
    Identifier* info = new Identifier();
    info->id_type = const_type;
    info->val_type = val_str;
    info->val.sval = $1;
    $$ = info;
}
| CONST_BOOL
{
    Trace("expr <- const_bool");
    Identifier* info = new Identifier();
    info->id_type = const_type;
    info->val_type = val_bool;
    info->val.bval = $1;
    $$ = info;
}

const_def: CONST ID '=' const_val ';' 
{
    Trace("Derived const define");
    if(insert(*$2)==-1) yyerror("[Error]Redefine symbol in same scope");
    set_type(*$2,$4->id_type,$4->val_type);
    set_val(*$2,$4->val);
}
| const_def ID '=' const_val ';'
{
    Trace("const_def <- const_def ID = expr;");
    if(insert(*$2)==-1) yyerror("[Error]Redefine symbol in same scope");
    set_type(*$2,$4->id_type,$4->val_type);
    set_val(*$2,$4->val);
};
arr_def: ids ':' ARRAY '[' expr ',' expr ']' OF type ';'
{
    for(int i=0;i<id_name_list.size();++i){

        if(insert(id_name_list[i])==-1) yyerror("[Error]Redefine symbol in same scope");
        set_type(id_name_list[i],arr_type,$10);
    }
    id_name_list.clear();
    Trace("Derived array define");
};
opt_procs: opt_procs procedure 
{
    Trace("Derived procedures defines");
}
|
{};
opt_stmts: opt_stmts stmt
{
    Trace("Derived statements");
}
|
{};
formal_args: ID ':' type
{
    if(id_type_list == nullptr){
        id_type_list = new vector<int>();
        id_name_list.clear();
    }
    if(insert(*$1)==-1) yyerror("[Error]Redefine symbol in same scope");
    set_type(*$1,para_type,$3);
    id_type_list->push_back($3);
    Trace("Derived single argment");
}
| formal_args ',' ID ':' type 
{
    if(insert(*$3)==-1) yyerror("[Error]Redefine symbol in same scope");
    set_type(*$3,para_type,$5);
    id_type_list->push_back($5);
    Trace("Derived multiple argument");
};
var_assign: ID ASS expr ';'
{
    Trace("Derived variable assignment");
    /* check */
    if(lookup(*$1)==-1) yyerror("[Error]Undefined symbol");
    Identifier info = get_info(*$1);
    if(info.id_type != var_type || info.val_type != $3->val_type) yyerror("[Error]Can't assign");
    genAssign(info);
};
arr_assign: arr_item ASS expr ';'
{
    Trace("arr_assign <- arr_item = expr");
    if($1->val_type != $3->val_type) yyerror("[Error]Can't assign");
};
command: PRINT
{
    genPrintStart();
} expr ';'
{
    Trace("command <- print expression");
    genPrint($3->val_type);
}
| PRINTLN
{
    genPrintStart();
} expr ';'
{
    genPrintln($3->val_type);
}
| READ ID ';'
{

}
| _RETURN ';'
{
    /* check return type */
    if(func_return_stack.back() != void_type) yyerror("[Error]wrong return type");
    
    genRet(false);
}
| _RETURN expr ';'
{
    if(func_return_stack.back() != $2->val_type) yyerror("[Error]wrong return type");

    genRet(true);
};
arr_item: ID '[' expr ']'
{
    Trace("arr_item <- id[arit_expr]");
    if(lookup(*$1)==-1) yyerror("[Error]Undefined symbol");
    Identifier info = get_info(*$1);
    if(info.id_type != arr_type) yyerror("[Error]Not an array");
    $$ = new Identifier(info);
};
type: INT_TYPE
{
    Trace("type <- int_type");
    $$ = val_int;
}
| REAL_TYPE
{
    Trace("type <- real_type");
    $$ = val_real;
}
| STR_TYPE
{
    Trace("type <- str_type");
    $$ = val_str;
}
| BOOL_TYPE
{
    Trace("type <- bool_type");
    $$ = val_bool;
};
ids: ID ',' ids
{
    id_name_list.push_back(*$1);
    Trace("ids <- ids ID");
}
| ID
{
    id_name_list.push_back(*$1);
    Trace("ids <- ID");
};
func_invo: ID '(' opt_exprs ')'
{
    Trace("Derive fun invo");
    /* check */

    if(lookup(*$1)==-1)yyerror("[Error]Undefined symbol");
    Identifier id_data = get_info(*$1);
    if(id_data.id_type != proc_type) yyerror("[Error]Not a func");
    Identifier* info = new Identifier(get_info(*$1));
    $$ = info;
    /* check parameter */
    if(id_data.data.arg_info->size() != invo_type_list->size()) yyerror("[Error]Wrong parameter");
    for(int i=0;i<invo_type_list->size();++i){
        if((*id_data.data.arg_info)[i] != (*invo_type_list)[i]) yyerror("[Error]Wrong parameter");
    }
    invo_type_list = nullptr;

    genProcInvo(*info);
};
proc_invo: ID '(' opt_exprs ')' ';'
{
    /* check */
    if(lookup(*$1)==-1)yyerror("Not defined var");
    Identifier id_data = get_info(*$1);
    if(id_data.id_type != proc_type) yyerror("[Error]Not a func");
    /* check parameter */
    if(id_data.data.arg_info->size() != invo_type_list->size()) yyerror("[Error]Wrong parameter");
    for(int i=0;i<invo_type_list->size();++i){
        if((*id_data.data.arg_info)[i] != (*invo_type_list)[i]) yyerror("[Error]Wrong parameter");
    }
    invo_type_list = nullptr;

    genProcInvo(id_data);
};

opt_exprs: exprs 
{

}
| 
{

};

exprs: exprs ',' expr
{
    invo_type_list->push_back($3->val_type);
    Trace("exprs <- expr,expr");
}
| expr
{
    if(invo_type_list == nullptr)
        invo_type_list = new vector<int>();
    invo_type_list->push_back($1->val_type);
};

%%

void yyerror(const char *s) {
    cerr << "\033[1;31m" << lineCount+1 << ": " << s << "\033[0m" << endl;
    exit(1);
}

int main(void) {
    out.open("a.jasm");
    yyparse();
    return 0;
}