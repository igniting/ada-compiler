#include <stdio.h>
#include "util.h"
#include "symbol.h"
#include "temp.h"
#include "tree.h"
#include "translate.h"

void doPatch(patchList tList, Temp_label label)
{
    for(;tList;tList = tList -> tail)
     *(tList->head) = label;
}

patchList joinPatch(patchList first, patchList second)
{
    if(!first) return second;
    for(;first->tail;first=first->tail);
    first->tail=second;
    return first;
}

Tr_exp Tr_Ex(T_exp ex)
{
 Tr_exp p = checked_malloc(sizeof(*p));
 p->kind = Tr_ex;
 p->u.ex = ex;
 return p;
}

Tr_exp Tr_Nx(T_stm nx)
{
 Tr_exp p = checked_malloc(sizeof(*p));
 p->kind = Tr_nx;
 p->u.nx = nx;
 return p;
}

Tr_exp Tr_Cx(patchList trues,patchList falses,T_stm stm)
{
 Tr_exp p = checked_malloc(sizeof(*p));
 p->kind = Tr_cx;
 p->u.cx.trues = trues;
 p->u.cx.falses = falses;
 p->u.cx.stm = stm;
 return p;
}

T_exp unEx(Tr_exp e) {
switch (e->kind) {
    case Tr_ex:
        return e->u.ex;
    case Tr_cx: {
        Temp_temp r = Temp_newtemp();
        Temp_label t = Temp_newlabel(), f = Temp_newlabel();
        doPatch(e->u.cx.trues, t);
        doPatch(e->u.cx.falses, f);
        return T_Eseq(T_Move(T_Temp(r), T_Int(1)),
                T_Eseq(e->u.cx.stm,
                    T_Eseq(T_Label(f),
                        T_Eseq(T_Move(T_Temp(r), T_Int(0)),
                            T_Eseq(T_Label(t),
                                   T_Temp(r))))));
   }
   case Tr_nx:
        return T_Eseq(e->u.nx, T_Int(0));
}
assert(0);
}
