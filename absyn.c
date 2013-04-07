/*
 * absyn.c - Abstract Syntax Functions. Most functions create an instance of an
 *           abstract syntax rule.
 */

#include "util.h"
#include "symbol.h" /* symbol table data structures */
#include "absyn.h"  /* abstract syntax data structures */

A_var A_SimpleVar(A_pos pos, S_symbol sym)
{A_var p = checked_malloc(sizeof(*p));
 p->kind=A_simpleVar;
 p->pos=pos;
 p->u.simple=sym;
 return p;
}

A_var A_FieldVar(A_pos pos, A_var var, S_symbol sym)
{A_var p = checked_malloc(sizeof(*p));
 p->kind=A_fieldVar;
 p->pos=pos;
 p->u.field.var=var;
 p->u.field.sym=sym;
 return p;
}

A_var A_SubscriptVar(A_pos pos, A_var var, A_exp exp)
{A_var p = checked_malloc(sizeof(*p));
 p->kind=A_subscriptVar;
 p->pos=pos;
 p->u.subscript.var=var;
 p->u.subscript.exp=exp;
 return p;
}

A_exp A_VarExp(A_pos pos, A_var var)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_varExp;
 p->pos=pos;
 p->u.var=var;
 return p;
}

A_exp A_NilExp(A_pos pos)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_nilExp;
 p->pos=pos;
 return p;
}

A_exp A_IntExp(A_pos pos, int i)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_intExp;
 p->pos=pos;
 p->u.intt=i;
 return p;
}

A_exp A_StringExp(A_pos pos, string s)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_stringExp;
 p->pos=pos;
 p->u.stringg=s;
 return p;
}

A_exp A_CallExp(A_pos pos, S_symbol func, A_expList args)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_callExp;
 p->pos=pos;
 p->u.call.func=func;
 p->u.call.args=args;
 return p;
}

A_exp A_OpExp(A_pos pos, A_oper oper, A_exp left, A_exp right)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_opExp;
 p->pos=pos;
 p->u.op.oper=oper;
 p->u.op.left=left;
 p->u.op.right=right;
 return p;
}

A_exp A_UnaryOpExp(A_pos pos, A_unaryOper oper, A_exp exp)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_unaryOpExp;
 p->pos=pos;
 p->u.unaryOp.oper = oper;
 p->u.unaryOp.exp=exp;
 return p;
}

A_exp A_RecordExp(A_pos pos, S_symbol typ, A_efieldList fields)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_recordExp;
 p->pos=pos;
 p->u.record.typ=typ;
 p->u.record.fields=fields;
 return p;
}

A_exp A_SeqExp(A_pos pos, A_expList seq)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_seqExp;
 p->pos=pos;
 p->u.seq=seq;
 return p;
}

A_exp A_AssignExp(A_pos pos, A_var var, A_exp exp)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_assignExp;
 p->pos=pos;
 p->u.assign.var=var;
 p->u.assign.exp=exp;
 return p;
}

A_exp A_IfExp(A_pos pos, A_expList cond_clauses, A_expList elsee)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_ifExp;
 p->pos=pos;
 p->u.iff.cond_clauses=cond_clauses;
 p->u.iff.elsee=elsee;
 return p;
}

A_exp A_WhileExp(A_pos pos, A_exp test)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_whileExp;
 p->pos=pos;
 p->u.whilee.test=test;
 return p;
}

A_exp A_ForExp(A_pos pos, A_exp var, A_exp reverse, A_exp range)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_forExp;
 p->pos=pos;
 p->u.forr.var=var;
 p->u.forr.reverse=reverse;
 p->u.forr.range=range;
 return p;
}

A_exp A_LoopExp(A_pos pos, A_exp labelopt, A_exp iteration, A_expList basicloop, A_exp idopt)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_loopExp;
 p->pos=pos;
 p->u.loop.labelopt=labelopt;
 p->u.loop.iteration=iteration;
 p->u.loop.basicloop=basicloop;
 p->u.loop.idopt=idopt;
 return p;
}

A_exp A_CondExp(A_pos pos, A_exp test, A_expList stmts)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_condExp;
 p->pos=pos;
 p->u.cond.test=test;
 p->u.cond.stmts=stmts;
 return p;
}

A_exp A_BreakExp(A_pos pos)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_breakExp;
 p->pos=pos;
 return p;
}

A_exp A_ExitExp(A_pos pos, A_exp exitname, A_exp exitcondition)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_exitExp;
 p->pos=pos;
 p->u.exit.exitname=exitname;
 p->u.exit.exitcondition=exitcondition;
 return p;
}

A_exp A_LetExp(A_pos pos, A_decList decs, A_exp body)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_letExp;
 p->pos=pos;
 p->u.let.decs=decs;
 p->u.let.body=body;
 return p;
}

A_exp A_ArrayExp(A_pos pos, S_symbol typ, A_exp size, A_exp init)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_arrayExp;
 p->pos=pos;
 p->u.array.typ=typ;
 p->u.array.size=size;
 p->u.array.init=init;
 return p;
}

A_exp A_ReturnExp(A_pos pos, A_exp retval)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_returnExp;
 p->pos=pos;
 p->u.retval=retval;
 return p;
}

A_exp A_GotoExp(A_pos pos, A_exp gotolabel)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_gotoExp;
 p->pos=pos;
 p->u.gotolabel=gotolabel;
 return p;
}
/*
A_exp A_EnumExp(A_pos pos, A_expList enumids)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_enumExp;
 p->pos=pos;
 p->u.enumids=enumids;
 return p;
}

A_exp A_IntdefExp(A_pos pos, A_exp intdef)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_intdefExp;
 p->pos=pos;
 p->u.intdef=intdef;
 return p;
}

A_exp A_FloatdefExp(A_pos pos, A_exp numdigits, A_exp rangeopt)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_floatdefExp;
 p->pos=pos;
 p->u.floatt.numdigits=numdigits;
 p->u.floatt.rangeopt=rangeopt;
 return p;
}

A_exp A_FixeddefExp(A_pos pos, A_exp delta, A_exp range)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_fixeddefExp;
 p->pos=pos;
 p->u.fixed.delta=delta;
 p->u.fixed.range=range;
 return p;
}

A_exp A_FixeddefdigitExp(A_pos pos, A_exp delta, A_exp numdigits, A_exp rangeopt)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_fixeddefdigitExp;
 p->pos=pos;
 p->u.fixeddig.delta=delta;
 p->u.fixeddig.numdigits=numdigits;
 p->u.fixeddig.rangeopt=rangeopt;
 return p;
}

A_exp A_UnconarraydefExp(A_pos pos, A_expList indexs, A_exp subtypeind)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_unconarraydefExp;
 p->pos=pos;
 p->u.unconarray.indexs=indexs;
 p->u.unconarray.subtypeind=subtypeind;
 return p;
}

A_exp A_ConarraydefExp(A_pos pos, A_expList iterindex, A_exp subtypeind)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_conarraydefExp;
 p->pos=pos;
 p->u.conarray.iterindex=iterindex;
 p->u.conarray.subtypeind=subtypeind;
 return p;
}

A_exp A_NullrecorddefExp(A_pos pos)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_nullrecorddefExp;
 p->pos=pos;
 return p;
}
*/
A_exp A_Pragma(A_pos pos, string pragmaname)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_pragma;
 p->pos=pos;
 p->u.pragmaname=pragmaname;
 return p;
}

A_exp A_Pragmalist(A_pos pos, A_exp name, A_expList pragmaargs)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_pragmalist;
 p->pos=pos;
 p->u.pragmalist.name=name;
 p->u.pragmalist.pragmaargs=pragmaargs;
 return p;
}
/*
A_exp A_RecorddefExp(A_pos pos, A_expList pragmas, A_exp complist)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_recorddefExp;
 p->pos=pos;
 p->u.recorddef.pragmas=pragmas;
 p->u.recorddef.complist=complist;
 return p;
}
*/
A_exp A_Alternative(A_pos pos, A_expList choices, A_expList stmts)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_alternative;
 p->pos=pos;
 p->u.alternative.choices=choices;
 p->u.alternative.stmts=stmts;
 return p;
}

A_exp A_Case(A_pos pos, A_exp header, A_expList pragmas, A_expList alternatives)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_caseExp;
 p->pos=pos;
 p->u.caseexp.header=header;
 p->u.caseexp.pragmas=pragmas;
 p->u.caseexp.alternatives=alternatives;
 return p;
}

A_exp A_RaiseExp(A_pos pos, A_exp nameopt)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_raiseExp;
 p->pos=pos;
 p->u.nameopt=nameopt;
 return p;
}

A_exp A_Procedure(A_pos pos, A_exp procedurename)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_procedure;
 p->pos=pos;
 p->u.procedurename=procedurename;
 return p;
}

A_exp A_FunctionUse(A_pos pos, A_exp name, A_expList value)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_functionUse;
 p->pos=pos;
 p->u.functionuse.name=name;
 p->u.functionuse.value=value;
 return p;
}

A_exp A_CompAssoc(A_pos pos, A_expList choices, A_exp expression)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_compAssoc;
 p->pos=pos;
 p->u.compassoc.choices=choices;
 p->u.compassoc.expression=expression;
 return p;
}

A_exp A_CompUnit(A_pos pos, A_expList contextspec, A_exp privatee, A_exp unit, A_expList pragmas)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_compUnit;
 p->pos=pos;
 p->u.compunit.contextspec=contextspec;
 p->u.compunit.privatee=privatee;
 p->u.compunit.unit=unit;
 p->u.compunit.pragmas=pragmas;
 return p;
}

A_exp A_Useclause(A_pos pos, A_exp type, A_expList names)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_useclause;
 p->pos=pos;
 p->u.useclause.type=type;
 p->u.useclause.names=names;
 return p;
}

A_exp A_ContextSpecwith(A_pos pos, A_expList withclause, A_expList useclauseopt)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_contextSpecwith;
 p->pos=pos;
 p->u.contextspecwith.withclause=withclause;
 p->u.contextspecwith.useclauseopt=useclauseopt;
 return p;
}

A_exp A_NotImplemented(A_pos pos, string msg)
{A_exp p = checked_malloc(sizeof(*p));
 p->kind=A_notImplemented;
 p->pos=pos;
 p->u.msg=msg;
 return p;
}

A_dec A_FunctionDec(A_pos pos, A_fundecList function)
{A_dec p = checked_malloc(sizeof(*p));
 p->kind=A_functionDec;
 p->pos=pos;
 p->u.function=function;
 return p;
}

A_dec A_VarDec(A_pos pos, S_symbol var, S_symbol typ, A_exp init)
{A_dec p = checked_malloc(sizeof(*p));
 p->kind=A_varDec;
 p->pos=pos;
 p->u.var.var=var;
 p->u.var.typ=typ;
 p->u.var.init=init;
 p->u.var.escape=TRUE;
 return p;
}

A_dec A_TypeDec(A_pos pos, A_nametyList type)
{A_dec p = checked_malloc(sizeof(*p));
 p->kind=A_typeDec;
 p->pos=pos;
 p->u.type=type;
 return p;
}

A_dec A_GlobalDec(A_pos pos)
{A_dec p = checked_malloc(sizeof(*p));
 p->kind=A_globalDec;
 p->pos=pos;
 return p;
}

A_ty A_NameTy(A_pos pos, S_symbol name)
{A_ty p = checked_malloc(sizeof(*p));
 p->kind=A_nameTy;
 p->pos=pos;
 p->u.name=name;
 return p;
}

A_ty A_RecordTy(A_pos pos, A_fieldList record)
{A_ty p = checked_malloc(sizeof(*p));
 p->kind=A_recordTy;
 p->pos=pos;
 p->u.record=record;
 return p;
}

A_ty A_ArrayTy(A_pos pos, S_symbol array)
{A_ty p = checked_malloc(sizeof(*p));
 p->kind=A_arrayTy;
 p->pos=pos;
 p->u.array=array;
 return p;
}

A_field A_Field(A_pos pos, S_symbol name, S_symbol typ)
{A_field p = checked_malloc(sizeof(*p));
 p->pos=pos;
 p->name=name;
 p->typ=typ;
 p->escape=TRUE;
 return p;
}

A_fieldList A_FieldList(A_field head, A_fieldList tail)
{A_fieldList p = checked_malloc(sizeof(*p));
 p->head=head;
 p->tail=tail;
 return p;
}

A_expList A_ExpList(A_exp head, A_expList tail)
{A_expList p = checked_malloc(sizeof(*p));
 p->head=head;
 p->tail=tail;
 return p;
}

A_fundec A_Fundec(A_pos pos, S_symbol name, A_fieldList params, S_symbol result,
		  A_exp body)
{A_fundec p = checked_malloc(sizeof(*p));
 p->pos=pos;
 p->name=name;
 p->params=params;
 p->result=result;
 p->body=body;
 return p;
}

A_fundecList A_FundecList(A_fundec head, A_fundecList tail)
{A_fundecList p = checked_malloc(sizeof(*p));
 p->head=head;
 p->tail=tail;
 return p;
}

A_decList A_DecList(A_dec head, A_decList tail)
{A_decList p = checked_malloc(sizeof(*p));
 p->head=head;
 p->tail=tail;
 return p;
}

A_namety A_Namety(S_symbol name, A_ty ty)
{A_namety p = checked_malloc(sizeof(*p));
 p->name=name;
 p->ty=ty;
 return p;
}

A_nametyList A_NametyList(A_namety head, A_nametyList tail)
{A_nametyList p = checked_malloc(sizeof(*p));
 p->head=head;
 p->tail=tail;
 return p;
}

A_efield A_Efield(S_symbol name, A_exp exp)
{A_efield p = checked_malloc(sizeof(*p));
 p->name=name;
 p->exp=exp;
 return p;
}

A_efieldList A_EfieldList(A_efield head, A_efieldList tail)
{A_efieldList p = checked_malloc(sizeof(*p));
 p->head=head;
 p->tail=tail;
 return p;
}

