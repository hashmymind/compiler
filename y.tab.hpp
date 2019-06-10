/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     LET = 258,
     BET = 259,
     NE = 260,
     AND = 261,
     OR = 262,
     ASS = 263,
     _BEGIN = 264,
     END = 265,
     MODULE = 266,
     PROCEDURE = 267,
     IF = 268,
     THEN = 269,
     ELSE = 270,
     WHILE = 271,
     DO = 272,
     VAR = 273,
     CONST = 274,
     ARRAY = 275,
     OF = 276,
     PRINT = 277,
     PRINTLN = 278,
     _RETURN = 279,
     READ = 280,
     CONTINUE = 281,
     BREAK = 282,
     INT_TYPE = 283,
     REAL_TYPE = 284,
     STR_TYPE = 285,
     BOOL_TYPE = 286,
     CONST_REAL = 287,
     ID = 288,
     CONST_STR = 289,
     CONST_INT = 290,
     CONST_BOOL = 291,
     UMINUS = 292
   };
#endif
/* Tokens.  */
#define LET 258
#define BET 259
#define NE 260
#define AND 261
#define OR 262
#define ASS 263
#define _BEGIN 264
#define END 265
#define MODULE 266
#define PROCEDURE 267
#define IF 268
#define THEN 269
#define ELSE 270
#define WHILE 271
#define DO 272
#define VAR 273
#define CONST 274
#define ARRAY 275
#define OF 276
#define PRINT 277
#define PRINTLN 278
#define _RETURN 279
#define READ 280
#define CONTINUE 281
#define BREAK 282
#define INT_TYPE 283
#define REAL_TYPE 284
#define STR_TYPE 285
#define BOOL_TYPE 286
#define CONST_REAL 287
#define ID 288
#define CONST_STR 289
#define CONST_INT 290
#define CONST_BOOL 291
#define UMINUS 292




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 36 "modula.y"
{
  int int_val;
  float real_val;
  bool bool_val;
  std::string* string_val;
  struct Identifier* id_info;
}
/* Line 1529 of yacc.c.  */
#line 131 "y.tab.hpp"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

