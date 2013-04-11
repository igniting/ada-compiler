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


void T_typeCheckExp(S_table table, A_exp v) {
 A_ty type;
 S_symbol T_int = S_Symbol("INTEGER");
 S_symbol T_float = S_Symbol("FLOAT");
 switch (v->kind) {
 case A_varExp:
   //Not used
   break;
 case A_nilExp:
   //Nothing here
   break;
 case A_intExp:
   //Not used
   break;
 case A_stringExp:
   //Nothing here
   break;
 case A_callExp:
   //Not used
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
        if(v->u.op.left->dec_type == T_int && v->u.op.right->dec_type == T_int)
            v->dec_type = T_int;
        else if(v->u.op.left->dec_type == T_float && v->u.op.right->dec_type == T_float)
            v->dec_type = T_float;
        else
        {
            EM_error(v->pos,"Invalid type");
            break;
        }
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
   //Do later
   break;
 case A_recordExp:
   //Not Used
   break;
 case A_seqExp:
   T_typeCheckExpList(table,v->u.seq);
   break;
 case A_assignExp:
   T_typeCheckExp(table,v->u.assign.name);
   T_typeCheckExp(table,v->u.assign.exp);
   break;
 case A_ifExp:
   T_typeCheckExpList(table,v->u.iff.cond_clauses);
   T_typeCheckExpList(table,v->u.iff.elsee);
   break;
 case A_whileExp:
   T_typeCheckExp(table,v->u.whilee.test);
   break;
 case A_forExp:
   T_typeCheckExp(table,v->u.forr.var);
   T_typeCheckExp(table,v->u.forr.reverse);
   T_typeCheckExp(table,v->u.forr.range);
   break;
 case A_loopExp:
   T_typeCheckExp(table,v->u.loop.labelopt);
   T_typeCheckExp(table,v->u.loop.iteration);
   T_typeCheckExpList(table,v->u.loop.basicloop);
   T_typeCheckExp(table,v->u.loop.idopt);
   break;
 case A_condExp:
   T_typeCheckExp(table,v->u.cond.test);
   T_typeCheckExpList(table,v->u.cond.stmts);
   break;
 case A_breakExp:
   //Nothing here
   break;
 case A_exitExp:
   T_typeCheckExp(table,v->u.exit.exitname);
   T_typeCheckExp(table,v->u.exit.exitcondition);
   break;
 case A_letExp:
   //Not used
   break;
 case A_arrayExp:
   //Not used
   break;
 case A_returnExp:
   T_typeCheckExp(table,v->u.retval);
   break;
 case A_gotoExp:
   T_typeCheckExp(table,v->u.gotolabel);
   break;
 case A_enumExp:
   T_typeCheckExpList(table,v->u.enumids);
   break;
 case A_intdefExp:
   T_typeCheckExp(table,v->u.intdef);
   break;
 case A_floatdefExp:
   T_typeCheckExp(table,v->u.floatt.numdigits);
   T_typeCheckExp(table,v->u.floatt.rangeopt);
   break;
 case A_fixeddefExp:
   T_typeCheckExp(table,v->u.fixed.delta);
   T_typeCheckExp(table,v->u.fixed.range);
   break;
 case A_fixeddefdigitExp:
   T_typeCheckExp(table,v->u.fixeddig.delta);
   T_typeCheckExp(table,v->u.fixeddig.numdigits);
   T_typeCheckExp(table,v->u.fixeddig.rangeopt);
   break;
 case A_unconarraydefExp:
   T_typeCheckExpList(table,v->u.unconarray.indexs);
   T_typeCheckExp(table,v->u.unconarray.subtypeind);
   break;
 case A_conarraydefExp:
   T_typeCheckExpList(table,v->u.conarray.iterindex);
   T_typeCheckExp(table,v->u.conarray.subtypeind);
   break;
 case A_nullrecorddefExp:
   //Nothing here
   break;
 case A_recorddefExp:
   T_typeCheckExpList(table,v->u.recorddef.pragmas);
   T_typeCheckExp(table,v->u.recorddef.complist);
   break;
 case A_pragma:
   //Nothing here
   break;
 case A_pragmalist:
   T_typeCheckExp(table,v->u.pragmalist.name);
   T_typeCheckExpList(table,v->u.pragmalist.pragmaargs);
   break; 
 case A_alternative:
   T_typeCheckExpList(table,v->u.alternative.choices);
   T_typeCheckExpList(table,v->u.alternative.stmts);
   break;
 case A_caseExp:
   T_typeCheckExp(table,v->u.caseexp.header);
   T_typeCheckExpList(table,v->u.caseexp.pragmas);
   T_typeCheckExpList(table,v->u.caseexp.alternatives);
   break;
 case A_raiseExp:
   T_typeCheckExp(table,v->u.nameopt);
   break;
 case A_procedure:
   T_typeCheckExp(table,v->u.procedurename);
   break;
 case A_functionUse:
   T_typeCheckExp(table,v->u.functionuse.name);
   T_typeCheckExpList(table,v->u.functionuse.value);
   break;
 case A_compAssoc:
   T_typeCheckExpList(table,v->u.compassoc.choices);
   T_typeCheckExp(table,v->u.compassoc.expression);
   break;
 case A_compUnit:
   T_typeCheckExpList(table,v->u.compunit.contextspec);
   T_typeCheckExp(table,v->u.compunit.privatee);
   T_typeCheckExp(table,v->u.compunit.unit);
   T_typeCheckExpList(table,v->u.compunit.pragmas);
   break;
 case A_useclause:
   T_typeCheckExp(table,v->u.useclause.type);
   T_typeCheckExpList(table,v->u.useclause.names);
   break;
 case A_contextSpecwith:
   T_typeCheckExpList(table,v->u.contextspecwith.withclause);
   T_typeCheckExpList(table,v->u.contextspecwith.useclauseopt);
   break;
 case A_subprogSpec:
   T_typeCheckExp(table,v->u.subprogSpec.name);
   T_typeCheckExpList(table,v->u.subprogSpec.formalpart);
   break;
 case A_nameConstr:
   T_typeCheckExp(table,v->u.nameconstr.name);
   T_typeCheckExp(table,v->u.nameconstr.constraint);
   break;
 case A_decimalConstr:
   T_typeCheckExp(table,v->u.decimalconstr.expression);
   T_typeCheckExp(table,v->u.decimalconstr.rangeopt);
   break;
 case A_notImplemented:
   //Nothing here
   break;
 default:
   assert(0); 
 } 
}

void T_typeCheckExpList(S_table table, A_expList l)
{
   A_expList e = l;
   while(e!=NULL)
   {
    T_typeCheckExp(table,e->head);
    e = e -> tail;
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
