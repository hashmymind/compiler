#pragma once
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include "symbol.hpp"
using namespace std;
extern ofstream out;
extern string ModuleName;

string get_label();

void genNOP();
void genModuleStart(string);
void genModuleEnd();
void genMainBegin();
void genMainEnd();
void genVar(Identifier);
void genGetVar(Identifier);
void genGetConst(Identifier);
void genCalcOP(char);
void genCondOP(string);
void genAssign(Identifier);
void genPrintStart();
void genPrint(int);
void genPrintln(int);
void genIfSec();
void genIfSecEnd();
void genIfEnd();
void genElseSec();
void genLoopStart();
void genLoopBodyStart();
void genLoopEnd();
void genProcStart(Identifier);
void genProcEnd();
void genRet(bool);
void genProcInvo(Identifier);