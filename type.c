#include <stdio.h>
#include "util.h"
#include "symbol.h" /* symbol table data structures */
#include "absyn.h"  /* abstract syntax data structures */
#include "type.h" /* function prototype */

/*
static void pr_var(A_var v);
static void pr_dec(A_dec v);
static void pr_ty( A_ty v);
static void pr_field( A_field v);
static void pr_fieldList( A_fieldList v);
static void pr_expList( A_expList v);
static void pr_fundec( A_fundec v);
static void pr_fundecList( A_fundecList v);
static void pr_decList( A_decList v);
static void pr_namety( A_namety v);
static void pr_nametyList( A_nametyList v);
static void pr_efield( A_efield v);
static void pr_efieldList( A_efieldList v);

static void indent( ) {
 int i;
 for (i = 0; i <= d; i++) fprintf(out, " ");
}

static void pr_var( A_var v) {
 indent(out, d);
 switch (v->kind) {
 case A_simpleVar:
   fprintf(out, "simpleVar(%s)", S_name(v->u.simple)); 
   break;
 case A_fieldVar:
   fprintf(out, "%s\n", "fieldVar(");
   pr_var(out, v->u.field.var, d+1); fprintf(out, "%s\n", ","); 
   indent(out, d+1); fprintf(out, "%s)", S_name(v->u.field.sym));
   break;
 case A_subscriptVar:
   fprintf(out, "%s\n", "subscriptVar(");
   pr_var(out, v->u.subscript.var, d+1); fprintf(out, "%s\n", ","); 
   pr_exp(out, v->u.subscript.exp, d+1); fprintf(out, "%s", ")");
   break;
 default:
   assert(0); 
 } 
}

static char str_oper[][12] = {
   "PLUS", "MINUS", "TIMES", "DIVIDE", 
   "EQUAL", "NOTEQUAL", "LESSTHAN", "LESSEQ", "GREAT", "GREATEQ", 
   "BINAND", "MOD", "REM", "TICK", "AND", "OR",
   "XOR", "IN", "NOTIN", "RANGE", "DOT"};
 
static void pr_oper( A_oper d) {
  fprintf(out, "%s", str_oper[d]);
}

static char str_unoper[][12] = {
    "NOT", "ABS" , "UNARYPLUS", "UNARYMINUS"};

static void pr_unoper( A_unaryOper d) {
  fprintf(out, "%s", str_unoper[d]);
}
*/

S_symbol T_typeCheckExp(S_table table, A_exp v) {
 A_ty type;
 switch (v->kind) {
 case A_varExp:
   break;
 case A_nilExp:
   break;
 case A_intExp:
   break;
 case A_stringExp:
   break;
 case A_callExp:
   break;
 case A_opExp:
   switch(v->u.op.oper) {
   case A_plusOp:
   case A_minusOp: 
   case A_timesOp:
   case A_divideOp:
   case A_eqOp:
   case A_neqOp:
   case A_ltOp:
   case A_leOp:
   case A_gtOp:
   case A_geOp:
   case A_binAndOp:
   case A_modOp:
   case A_remOp:
        if(T_typeCheckExp(table,v->u.op.left) != T_typeCheckExp(table,v->u.op.right))
            EM_error(v->pos,"Type Error!");
        break;
   case A_tickOp:
   case A_andOp:
   case A_orOp:
   case A_xorOp:
   case A_inOp:
   case A_notInOp:
   case A_rangeOp:
   case A_dotOp:
    break;
   default: assert(0);
   }
   break;
 case A_unaryOpExp:
   break;
 case A_recordExp:
   break;
 case A_seqExp:
   break;
 case A_assignExp:
   break;
 case A_ifExp:
   break;
 case A_whileExp:
   break;
 case A_forExp:
   break;
 case A_loopExp:
   break;
 case A_condExp:
   break;
 case A_breakExp:
   break;
 case A_exitExp:
   break;
 case A_letExp:
   break;
 case A_arrayExp:
   break;
 case A_returnExp:
   break;
 case A_gotoExp:
   break;
 case A_pragma:
   break;
 case A_pragmalist:
   break; 
 case A_alternative:
   break;
 case A_caseExp:
   break;
 case A_raiseExp:
   break;
 case A_procedure:
   break;
 case A_functionUse:
   break;
 case A_compAssoc:
   break;
 case A_compUnit:
   break;
 case A_useclause:
   break;
 case A_contextSpecwith:
   break;
 case A_subprogSpec:
   break;
 case A_identExp:
   type = S_look(table,v->u.ident);
   switch(type->kind) {
    case A_numTy: return S_Symbol("INT"); break;
    default: break;
   }
 case A_notImplemented:
   break;
 default:
   assert(0); 
 } 
}

/*
static void pr_dec( A_dec v) {
 indent(out, d);
 switch (v->kind) {
 case A_functionDec:
   fprintf(out, "functionDec(\n"); 
   pr_fundecList(out, v->u.function, d+1); fprintf(out, ")");
   break;
 case A_varDec:
   fprintf(out, "varDec(%s,\n", S_name(v->u.var.var));
   if (v->u.var.typ) {
     indent(out, d+1); fprintf(out, "%s,\n", S_name(v->u.var.typ)); 
   }
   pr_exp(out, v->u.var.init, d+1); fprintf(out, ",\n");
   indent(out, d+1); fprintf(out, "%s", v->u.var.escape ? "TRUE)" : "FALSE)");
   break;
 case A_typeDec:
   fprintf(out, "typeDec(\n"); 
   pr_nametyList(out, v->u.type, d+1); fprintf(out, ")");
   break;
 default:
   assert(0); 
 } 
}

static void pr_ty( A_ty v) {
 indent(out, d);
 switch (v->kind) {
 case A_nameTy:
   fprintf(out, "nameTy(%s)", S_name(v->u.name));
   break;
 case A_recordTy:
   fprintf(out, "recordTy(\n");
   pr_fieldList(out, v->u.record, d+1); fprintf(out, ")");
   break;
 case A_arrayTy:
   fprintf(out, "arrayTy(%s)", S_name(v->u.array));
   break;
 default:
   assert(0); 
 } 
}

static void pr_field( A_field v) {
 indent(out, d);
 fprintf(out, "field(%s,\n", S_name(v->name));
 indent(out, d+1); fprintf(out, "%s,\n", S_name(v->typ));
 indent(out, d+1); fprintf(out, "%s", v->escape ? "TRUE)" : "FALSE)");
}

static void pr_fieldList( A_fieldList v) {
 indent(out, d);
 if (v) {
   fprintf(out, "fieldList(\n");
   pr_field(out, v->head, d+1); fprintf(out, ",\n");
   pr_fieldList(out, v->tail, d+1); fprintf(out, ")");
 }
 else fprintf(out, "fieldList()");
}

static void pr_expList( A_expList v) {
 indent(out, d);
 if (v) {
   fprintf(out, "expList(\n"); 
   pr_exp(out, v->head, d+1); fprintf(out, ",\n");
   pr_expList(out, v->tail, d+1);
   fprintf(out, ")");
 }
 else fprintf(out, "expList()"); 

}

static void pr_fundec( A_fundec v) {
 indent(out, d);
 fprintf(out, "fundec(%s,\n", S_name(v->name));
 pr_fieldList(out, v->params, d+1); fprintf(out, ",\n");
 if (v->result) {
   indent(out, d+1); fprintf(out, "%s,\n", S_name(v->result));
 }
 pr_exp(out, v->body, d+1); fprintf(out, ")");
}

static void pr_fundecList( A_fundecList v) {
 indent(out, d);
 if (v) {
   fprintf(out, "fundecList(\n"); 
   pr_fundec(out, v->head, d+1); fprintf(out, ",\n");
   pr_fundecList(out, v->tail, d+1); fprintf(out, ")");
 }
 else fprintf(out, "fundecList()");
}

static void pr_decList( A_decList v) {
 indent(out, d);
 if (v) {
   fprintf(out, "decList(\n"); 
   pr_dec(out, v->head, d+1); fprintf(out, ",\n");
   pr_decList(out, v->tail, d+1);
   fprintf(out, ")");
 }
 else fprintf(out, "decList()"); 

}

static void pr_namety( A_namety v) {
 indent(out, d);
 fprintf(out, "namety(%s,\n", S_name(v->name)); 
 pr_ty(out, v->ty, d+1); fprintf(out, ")");
}

static void pr_nametyList( A_nametyList v) {
 indent(out, d);
 if (v) {
   fprintf(out, "nametyList(\n"); 
   pr_namety(out, v->head, d+1); fprintf(out, ",\n");
   pr_nametyList(out, v->tail, d+1); fprintf(out, ")");
 }
 else fprintf(out, "nametyList()");
}

static void pr_efield( A_efield v) {
 indent(out, d);
 if (v) {
   fprintf(out, "efield(%s,\n", S_name(v->name));
   pr_exp(out, v->exp, d+1); fprintf(out, ")");
 }
 else fprintf(out, "efield()");
}

static void pr_efieldList( A_efieldList v) {
 indent(out, d);
 if (v) {
   fprintf(out, "efieldList(\n"); 
   pr_efield(out, v->head, d+1); fprintf(out, ",\n");
   pr_efieldList(out, v->tail, d+1); fprintf(out, ")");
 }
 else fprintf(out, "efieldList()");
}
*/
