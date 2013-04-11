void Ty_typeCheckExp(S_table table, A_exp e);
void Ty_typeCheckExpList(S_table table, A_expList l);
#define Ty_int S_Symbol("INTEGER")
#define Ty_float S_Symbol("FLOAT")
S_symbol Ty_numberType(string);
