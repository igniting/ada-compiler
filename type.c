#include <stdio.h>
#include <string.h>
#include "util.h"
#include "symbol.h" /* symbol table data structures */
#include "absyn.h"  /* abstract syntax data structures */
#include "temp.h"
#include "tree.h"
#include "translate.h"
#include "type.h" /* function prototype */

Tr_exp Ty_typeCheckExp(S_table table, A_exp v) {
 A_ty type;
 T_exp left,right;
 switch (v->kind) {
 case A_varExp:
   //Not used
   break;
 case A_nilExp:
    return NULL;
 case A_numberExp:
   if(v->dec_type=Ty_int) return Tr_Ex(T_Int((IntBaseConverter(v->u.number))));
   return Tr_Ex(T_Float((FloatBaseConverter(v->u.number))));
 case A_stringExp:
   return Tr_Ex(T_String(v->u.stringg));
 case A_callExp:
   //Not used
   break;
 case A_opExp:
   switch(v->u.op.oper) {
   case A_plusOp:
        left = unEx(Ty_typeCheckExp(table,v->u.op.left));
        right = unEx(Ty_typeCheckExp(table,v->u.op.right));
        if(v->u.op.left->dec_type == Ty_int && v->u.op.right->dec_type == Ty_int)
        {
            v->dec_type = Ty_int;
            return Tr_Ex(T_Binop(T_plus,left,right));
        }
        else if(v->u.op.left->dec_type == Ty_float && v->u.op.right->dec_type == Ty_float)
        {
            v->dec_type = Ty_float;
            return Tr_Ex(T_Binop(T_plus,left,right));
        }
        else
        {
            EM_error(v->pos,"Invalid types of left and right operand for +");
            break;
        }       
   case A_minusOp:
        left = unEx(Ty_typeCheckExp(table,v->u.op.left));
        right = unEx(Ty_typeCheckExp(table,v->u.op.right));
        if(v->u.op.left->dec_type == Ty_int && v->u.op.right->dec_type == Ty_int)
        {
            v->dec_type = Ty_int;
            return Tr_Ex(T_Binop(T_minus,left,right));
        }
        else if(v->u.op.left->dec_type == Ty_float && v->u.op.right->dec_type == Ty_float)
        {
            v->dec_type = Ty_float;
            return Tr_Ex(T_Binop(T_minus,left,right));
        }
        else
        {
            EM_error(v->pos,"Invalid types of left and right operand for -");
            break;
        }
   case A_timesOp:
        left = unEx(Ty_typeCheckExp(table,v->u.op.left));
        right = unEx(Ty_typeCheckExp(table,v->u.op.right));
        if(v->u.op.left->dec_type == Ty_int && v->u.op.right->dec_type == Ty_int)
        {
            v->dec_type = Ty_int;
            return Tr_Ex(T_Binop(T_mul,left,right));
        }
        else if(v->u.op.left->dec_type == Ty_float && v->u.op.right->dec_type == Ty_float)
        {
            v->dec_type = Ty_float;
            return Tr_Ex(T_Binop(T_mul,left,right));
        }
        else
        {
            EM_error(v->pos,"Invalid types of left and right operand for *");
            break;
        }
   case A_divideOp:
        left = unEx(Ty_typeCheckExp(table,v->u.op.left));
        right = unEx(Ty_typeCheckExp(table,v->u.op.right));
        if(v->u.op.left->dec_type == Ty_int && v->u.op.right->dec_type == Ty_int)
        {
            v->dec_type = Ty_int;
            return Tr_Ex(T_Binop(T_div,left,right));
        }
        else if(v->u.op.left->dec_type == Ty_float && v->u.op.right->dec_type == Ty_float)
        {
            v->dec_type = Ty_float;
            return Tr_Ex(T_Binop(T_div,left,right));
        }
        else
        {
            EM_error(v->pos,"Invalid types of left and right operand for /");
            break;
        }
   case A_eqOp:
        left = unEx(Ty_typeCheckExp(table,v->u.op.left));
        right = unEx(Ty_typeCheckExp(table,v->u.op.right));
        if(v->u.op.left->dec_type == Ty_int && v->u.op.right->dec_type == Ty_int)
        {
            v->dec_type = Ty_int;
            //return Tr_Cx(T_Cjump(T_eq,left,right,NULL,NULL);
            break;
        }
        else if(v->u.op.left->dec_type == Ty_float && v->u.op.right->dec_type == Ty_float)
        {
            v->dec_type = Ty_float;
            //return Tr_Cx(T_Cjump(T_eq,left,right,NULL,NULL));
            break;
        }
        else
        {
            EM_error(v->pos,"Invalid types of left and right operand for =");
            break;
        }
   case A_neqOp:
        left = unEx(Ty_typeCheckExp(table,v->u.op.left));
        right = unEx(Ty_typeCheckExp(table,v->u.op.right));
        if(v->u.op.left->dec_type == Ty_int && v->u.op.right->dec_type == Ty_int)
        {
            v->dec_type = Ty_int;
            //return Tr_Cx(T_Cjump(T_ne,left,right,NULL,NULL));
            break;
        }
        else if(v->u.op.left->dec_type == Ty_float && v->u.op.right->dec_type == Ty_float)
        {
            v->dec_type = Ty_float;
            //return Tr_Cx(T_Cjump(T_ne,left,right,NULL,NULL));
            break;
        }
        else
        {
            EM_error(v->pos,"Invalid types of left and right operand for /=");
            break;
        }
   case A_ltOp:
        left = unEx(Ty_typeCheckExp(table,v->u.op.left));
        right = unEx(Ty_typeCheckExp(table,v->u.op.right));
        if(v->u.op.left->dec_type == Ty_int && v->u.op.right->dec_type == Ty_int)
        {
            v->dec_type = Ty_int;
            //return Tr_Cx(T_Cjump(T_ne,left,right,NULL,NULL));
            break;
        }
        else if(v->u.op.left->dec_type == Ty_float && v->u.op.right->dec_type == Ty_float)
        {
            v->dec_type = Ty_float;
            //return Tr_Cx(T_Cjump(T_ne,left,right,NULL,NULL));
            break;
        }
        else
        {
            EM_error(v->pos,"Invalid types of left and right operand for <");
            break;
        }
   case A_leOp:
        left = unEx(Ty_typeCheckExp(table,v->u.op.left));
        right = unEx(Ty_typeCheckExp(table,v->u.op.right));
        if(v->u.op.left->dec_type == Ty_int && v->u.op.right->dec_type == Ty_int)
        {
            v->dec_type = Ty_int;
            //return Tr_Cx(T_Cjump(T_ne,left,right,NULL,NULL));
            break;
        }
        else if(v->u.op.left->dec_type == Ty_float && v->u.op.right->dec_type == Ty_float)
        {
            v->dec_type = Ty_float;
            //return Tr_Cx(T_Cjump(T_ne,left,right,NULL,NULL));
            break;
        }
        else
        {
            EM_error(v->pos,"Invalid types of left and right operand for <=");
            break;
        }
   case A_gtOp:
        left = unEx(Ty_typeCheckExp(table,v->u.op.left));
        right = unEx(Ty_typeCheckExp(table,v->u.op.right));
        if(v->u.op.left->dec_type == Ty_int && v->u.op.right->dec_type == Ty_int)
        {
            v->dec_type = Ty_int;
            //return Tr_Cx(T_Cjump(T_ne,left,right,NULL,NULL));
            break;
        }
        else if(v->u.op.left->dec_type == Ty_float && v->u.op.right->dec_type == Ty_float)
        {
            v->dec_type = Ty_float;
            //return Tr_Cx(T_Cjump(T_ne,left,right,NULL,NULL));
            break;
        }
        else
        {
            EM_error(v->pos,"Invalid types of left and right operand for >");
            break;
        }
   case A_geOp:
        left = unEx(Ty_typeCheckExp(table,v->u.op.left));
        right = unEx(Ty_typeCheckExp(table,v->u.op.right));
        if(v->u.op.left->dec_type == Ty_int && v->u.op.right->dec_type == Ty_int)
        {
            v->dec_type = Ty_int;
            //return Tr_Cx(T_Cjump(T_ne,left,right,NULL,NULL));
            break;
        }
        else if(v->u.op.left->dec_type == Ty_float && v->u.op.right->dec_type == Ty_float)
        {
            v->dec_type = Ty_float;
            //return Tr_Cx(T_Cjump(T_ne,left,right,NULL,NULL));
            break;
        }
        else
        {
            EM_error(v->pos,"Invalid types of left and right operand for >=");
            break;
        }
   case A_binAndOp:
        break;
   case A_modOp:
        break;
   case A_remOp:
        left = unEx(Ty_typeCheckExp(table,v->u.op.left));
        right = unEx(Ty_typeCheckExp(table,v->u.op.right));
        if(v->u.op.left->dec_type == Ty_int && v->u.op.right->dec_type == Ty_int)
        {
            v->dec_type = Ty_int;
            return Tr_Ex(T_Binop(T_div,left,right));
        }
        else if(v->u.op.left->dec_type == Ty_float && v->u.op.right->dec_type == Ty_float)
        {
            v->dec_type = Ty_float;
            return Tr_Ex(T_Binop(T_div,left,right));
        }
        else
        {
            EM_error(v->pos,"Invalid types of left and right operand for rem");
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
   case A_expOp:
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
   Ty_typeCheckExpList(table,v->u.seq);
   break;
 case A_assignExp:
   Ty_typeCheckExp(table,v->u.assign.name);
   Ty_typeCheckExp(table,v->u.assign.exp);
   if(v->u.assign.name->dec_type == v->u.assign.exp->dec_type)
    v->dec_type = v->u.assign.exp->dec_type;
   else
   {
    EM_error(v->pos,"Invalid types in assignment");
    break;
   }   
   break;
 case A_ifExp:
   Ty_typeCheckExpList(table,v->u.iff.cond_clauses);
   Ty_typeCheckExpList(table,v->u.iff.elsee);
   break;
 case A_whileExp:
   Ty_typeCheckExp(table,v->u.whilee.test);
   break;
 case A_forExp:
   Ty_typeCheckExp(table,v->u.forr.var);
   Ty_typeCheckExp(table,v->u.forr.reverse);
   Ty_typeCheckExp(table,v->u.forr.range);
   break;
 case A_loopExp:
   Ty_typeCheckExp(table,v->u.loop.labelopt);
   Ty_typeCheckExp(table,v->u.loop.iteration);
   Ty_typeCheckExpList(table,v->u.loop.basicloop);
   Ty_typeCheckExp(table,v->u.loop.idopt);
   break;
 case A_condExp:
   Ty_typeCheckExp(table,v->u.cond.test);
   Ty_typeCheckExpList(table,v->u.cond.stmts);
   break;
 case A_breakExp:
   //Nothing here
   break;
 case A_exitExp:
   Ty_typeCheckExp(table,v->u.exit.exitname);
   Ty_typeCheckExp(table,v->u.exit.exitcondition);
   break;
 case A_letExp:
   //Not used
   break;
 case A_arrayExp:
   //Not used
   break;
 case A_returnExp:
   Ty_typeCheckExp(table,v->u.retval);
   break;
 case A_gotoExp:
   Ty_typeCheckExp(table,v->u.gotolabel);
   break;
 case A_enumExp:
   Ty_typeCheckExpList(table,v->u.enumids);
   break;
 case A_intdefExp:
   Ty_typeCheckExp(table,v->u.intdef);
   break;
 case A_floatdefExp:
   Ty_typeCheckExp(table,v->u.floatt.numdigits);
   Ty_typeCheckExp(table,v->u.floatt.rangeopt);
   break;
 case A_fixeddefExp:
   Ty_typeCheckExp(table,v->u.fixed.delta);
   Ty_typeCheckExp(table,v->u.fixed.range);
   break;
 case A_fixeddefdigitExp:
   Ty_typeCheckExp(table,v->u.fixeddig.delta);
   Ty_typeCheckExp(table,v->u.fixeddig.numdigits);
   Ty_typeCheckExp(table,v->u.fixeddig.rangeopt);
   break;
 case A_unconarraydefExp:
   Ty_typeCheckExpList(table,v->u.unconarray.indexs);
   Ty_typeCheckExp(table,v->u.unconarray.subtypeind);
   break;
 case A_conarraydefExp:
   Ty_typeCheckExpList(table,v->u.conarray.iterindex);
   Ty_typeCheckExp(table,v->u.conarray.subtypeind);
   break;
 case A_nullrecorddefExp:
   //Nothing here
   break;
 case A_recorddefExp:
   Ty_typeCheckExpList(table,v->u.recorddef.pragmas);
   Ty_typeCheckExp(table,v->u.recorddef.complist);
   break;
 case A_pragma:
   //Nothing here
   break;
 case A_pragmalist:
   Ty_typeCheckExp(table,v->u.pragmalist.name);
   Ty_typeCheckExpList(table,v->u.pragmalist.pragmaargs);
   break; 
 case A_alternative:
   Ty_typeCheckExpList(table,v->u.alternative.choices);
   Ty_typeCheckExpList(table,v->u.alternative.stmts);
   break;
 case A_caseExp:
   Ty_typeCheckExp(table,v->u.caseexp.header);
   Ty_typeCheckExpList(table,v->u.caseexp.pragmas);
   Ty_typeCheckExpList(table,v->u.caseexp.alternatives);
   break;
 case A_raiseExp:
   Ty_typeCheckExp(table,v->u.nameopt);
   break;
 case A_procedure:
   Ty_typeCheckExp(table,v->u.procedurename);
   break;
 case A_functionUse:
   Ty_typeCheckExp(table,v->u.functionuse.name);
   Ty_typeCheckExpList(table,v->u.functionuse.value);
   break;
 case A_compAssoc:
   Ty_typeCheckExpList(table,v->u.compassoc.choices);
   Ty_typeCheckExp(table,v->u.compassoc.expression);
   break;
 case A_compUnit:
   Ty_typeCheckExpList(table,v->u.compunit.contextspec);
   Ty_typeCheckExp(table,v->u.compunit.privatee);
   Ty_typeCheckExp(table,v->u.compunit.unit);
   Ty_typeCheckExpList(table,v->u.compunit.pragmas);
   break;
 case A_useclause:
   Ty_typeCheckExp(table,v->u.useclause.type);
   Ty_typeCheckExpList(table,v->u.useclause.names);
   break;
 case A_contextSpecwith:
   Ty_typeCheckExpList(table,v->u.contextspecwith.withclause);
   Ty_typeCheckExpList(table,v->u.contextspecwith.useclauseopt);
   break;
 case A_subprogSpec:
   Ty_typeCheckExp(table,v->u.subprogSpec.name);
   Ty_typeCheckExpList(table,v->u.subprogSpec.formalpart);
   break;
 case A_nameConstr:
   Ty_typeCheckExp(table,v->u.nameconstr.name);
   Ty_typeCheckExp(table,v->u.nameconstr.constraint);
   break;
 case A_decimalConstr:
   Ty_typeCheckExp(table,v->u.decimalconstr.expression);
   Ty_typeCheckExp(table,v->u.decimalconstr.rangeopt);
   break;
 case A_notImplemented:
   return NULL;
 default:
   assert(0); 
 } 
}

Tr_exp Ty_typeCheckExpList(S_table table, A_expList l)
{
   A_expList e = l;
   while(e!=NULL)
   {
    Ty_typeCheckExp(table,e->head);
    e = e -> tail;
   }
}
