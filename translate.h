typedef struct patchList_ *patchList;
struct patchList_ {Temp_label *head; patchList tail;};
patchList PatchList(Temp_label *head, patchList tail); 
void doPatch(patchList tList, Temp_label label);
patchList joinPatch(patchList first, patchList second);

typedef struct Tr_exp_ *Tr_exp;

struct Cx {patchList trues; patchList falses; T_stm stm;};
struct Tr_exp_
    {
        enum {Tr_ex, Tr_nx, Tr_cx} kind;
        union {T_exp ex; T_stm nx; struct Cx cx;} u;
    };

Tr_exp Tr_Ex(T_exp ex);
Tr_exp Tr_Nx(T_stm nx);
Tr_exp Tr_Cx(patchList trues,patchList falses,T_stm stm);
T_exp unEx(Tr_exp e);
T_stm unNx(Tr_exp e);
struct Cx unCx(Tr_exp e);
