/*
 * absyn.h - Abstract Syntax Header
 *
 * All types and functions declared in this header file begin with "A_"
 * Linked list types end with "..list"
 */

/* Type Definitions */

typedef int A_pos;

typedef struct A_var_ *A_var;
typedef struct A_exp_ *A_exp;
typedef struct A_dec_ *A_dec;
typedef struct A_ty_ *A_ty;

typedef struct A_decList_ *A_decList;
typedef struct A_expList_ *A_expList;
typedef struct A_field_ *A_field;
typedef struct A_fieldList_ *A_fieldList;
typedef struct A_fundec_ *A_fundec;
typedef struct A_fundecList_ *A_fundecList;
typedef struct A_namety_ *A_namety;
typedef struct A_nametyList_ *A_nametyList;
typedef struct A_efield_ *A_efield;
typedef struct A_efieldList_ *A_efieldList;

typedef enum {A_plusOp, A_minusOp, A_timesOp, A_divideOp,
	     A_eqOp, A_neqOp, A_ltOp, A_leOp, A_gtOp, A_geOp,
	     A_binAndOp, A_modOp, A_remOp, A_tickOp,
	     A_andOp, A_orOp, A_xorOp,
	     A_inOp, A_notInOp,
	     A_rangeOp,
	     A_dotOp} A_oper;

typedef enum {A_notOp, A_absOp, A_unaryplusOp, A_unaryminusOp} A_unaryOper;

struct A_var_
       {enum {A_simpleVar, A_fieldVar, A_subscriptVar} kind;
        A_pos pos;
	union {S_symbol simple;
	       struct {A_var var;
		       S_symbol sym;} field;
	       struct {A_var var;
		       A_exp exp;} subscript;
	     } u;
      };

struct A_exp_
      {enum {A_varExp, A_nilExp, A_intExp, A_stringExp, A_callExp,
	       A_opExp, A_unaryOpExp, A_recordExp, A_seqExp, A_assignExp,
	       A_ifExp, A_condExp, A_whileExp, A_forExp, A_loopExp, A_breakExp, A_exitExp, 
	       A_letExp, A_arrayExp, A_returnExp, A_gotoExp, A_enumExp, A_intdefExp,
	       A_floatdefExp, A_fixeddefExp, A_fixeddefdigitExp, A_unconarraydefExp,
	       A_conarraydefExp, A_nullrecorddefExp, A_recorddefExp, A_pragma,
	       A_pragmalist, A_alternative, A_caseExp, A_raiseExp, A_procedure, 
	       A_functionUse, A_compAssoc, A_compUnit, A_useclause,
	       A_contextSpecwith, A_subprogSpec, A_nameConstr, A_decimalConstr,
	       A_identExp, A_notImplemented} kind;
       A_pos pos;
       S_symbol dec_type;
       union {A_var var;
	      /* nil; - needs only the pos */
	      int intt;
	      string stringg;
	      struct {S_symbol func; A_expList args;} call;
	      struct {A_oper oper; A_exp left; A_exp right;} op;
	      struct {A_unaryOper oper; A_exp exp;} unaryOp;
	      struct {S_symbol typ; A_efieldList fields;} record;
	      A_expList seq;
	      struct {A_exp name; A_exp exp;} assign;
	      struct {A_expList cond_clauses, elsee;} iff; /* elsee is optional */
	      struct {A_exp test; A_expList stmts;} cond;
	      struct {A_exp test;} whilee;
	      struct {A_exp var; A_exp reverse, range;} forr;
	      struct {A_exp labelopt,iteration,idopt; A_expList basicloop;} loop;
	      /* breakk; - need only the pos */
	      struct {A_exp exitname,exitcondition;} exit;
	      struct {A_decList decs; A_exp body;} let;
	      struct {S_symbol typ; A_exp size, init;} array;
	      A_exp retval;
	      A_exp gotolabel;
  	      A_expList enumids;
  	      A_exp intdef;
  	      struct {A_exp numdigits, rangeopt;} floatt;
  	      struct {A_exp delta, range;} fixed;
  	      struct {A_exp delta, numdigits, rangeopt;} fixeddig;
  	      struct {A_expList indexs; A_exp subtypeind;} unconarray;
  	      struct {A_expList iterindex; A_exp subtypeind;} conarray;
  	      string pragmaname;
  	      struct {A_exp name; A_expList pragmaargs;} pragmalist;
  	      /* Null record requires only pos */
  	      struct {A_expList pragmas;A_exp complist;} recorddef;
  	      struct {A_expList choices, stmts;} alternative;
  	      struct {A_exp header; A_expList pragmas, alternatives;} caseexp;
  	      A_exp nameopt;
  	      A_exp procedurename;
  	      struct {A_exp name; A_expList value;} functionuse;
  	      struct {A_expList choices; A_exp expression;} compassoc;
  	      struct {A_exp privatee, unit; A_expList contextspec, pragmas;} compunit;
  	      struct {A_expList names; A_exp type;} useclause;
  	      struct {A_expList withclause, useclauseopt;} contextspecwith;
  	      struct {A_exp name; A_expList formalpart;} subprogSpec;
  	      struct {A_exp name, constraint;} nameconstr;
  	      struct {A_exp expression, rangeopt;} decimalconstr; 
  	      S_symbol ident;
	      string msg;
	    } u;
     };

struct A_dec_ 
    {enum {A_functionDec, A_varDec, A_typeDec, A_globalDec} kind;
     A_pos pos;
     union {A_fundecList function;
	    /* escape may change after the initial declaration */
	    struct {S_symbol var; S_symbol typ; A_exp init; bool escape;} var;
	    A_nametyList type;
	    /* For now we'll use global declaration for every dec */
	  } u;
   };

struct A_ty_ {enum {A_nameTy, A_recordTy, A_arrayTy, A_objectTy, A_numTy, 
                    A_typeDecTy} kind;
	      A_pos pos;
          S_symbol dec_type;
	      union {S_symbol name;
		     A_fieldList record;
		     S_symbol array;
		     struct {string qualifier; A_exp subtype,init;} obj;
		     A_exp assignexp;
		     struct {A_expList discrimopt; A_exp typecomp;} typedec;
		   } u;
	    };

/* Linked lists and nodes of lists */

struct A_field_ {S_symbol name, typ; A_pos pos; bool escape;};
struct A_fieldList_ {A_field head; A_fieldList tail;};
struct A_expList_ {A_exp head; A_expList tail;};
struct A_fundec_ {A_pos pos;
                 S_symbol name; A_fieldList params; 
		 S_symbol result; A_exp body;};

struct A_fundecList_ {A_fundec head; A_fundecList tail;};
struct A_decList_ {A_dec head; A_decList tail;};
struct A_namety_ {S_symbol name; A_ty ty;};
struct A_nametyList_ {A_namety head; A_nametyList tail;};
struct A_efield_ {S_symbol name; A_exp exp;};
struct A_efieldList_ {A_efield head; A_efieldList tail;};


/* Function Prototypes */
A_var A_SimpleVar(A_pos pos, S_symbol sym);
A_var A_FieldVar(A_pos pos, A_var var, S_symbol sym);
A_var A_SubscriptVar(A_pos pos, A_var var, A_exp exp);
A_exp A_VarExp(A_pos pos, A_var var);
A_exp A_NilExp(A_pos pos);
A_exp A_IntExp(A_pos pos, int i);
A_exp A_StringExp(A_pos pos, string s);
A_exp A_CallExp(A_pos pos, S_symbol func, A_expList args);
A_exp A_OpExp(A_pos pos, A_oper oper, A_exp left, A_exp right);
A_exp A_UnaryOpExp(A_pos pos, A_unaryOper oper, A_exp exp);
A_exp A_RecordExp(A_pos pos, S_symbol typ, A_efieldList fields);
A_exp A_SeqExp(A_pos pos, A_expList seq);
A_exp A_AssignExp(A_pos pos, A_exp name, A_exp exp);
A_exp A_IfExp(A_pos pos, A_expList cond_clauses, A_expList elsee);
A_exp A_CondExp(A_pos pos, A_exp test, A_expList stmts);
A_exp A_WhileExp(A_pos pos, A_exp test);
A_exp A_ForExp(A_pos pos, A_exp var, A_exp reverse, A_exp range);
A_exp A_LoopExp(A_pos pos, A_exp labelopt, A_exp iteration, A_expList basicloop, A_exp idopt);
A_exp A_BreakExp(A_pos pos);
A_exp A_ExitExp(A_pos pos, A_exp exitname, A_exp exitcondition);
A_exp A_LetExp(A_pos pos, A_decList decs, A_exp body);
A_exp A_ArrayExp(A_pos pos, S_symbol typ, A_exp size, A_exp init);
A_exp A_ReturnExp(A_pos, A_exp retval);
A_exp A_GotoExp(A_pos, A_exp gotolabel);
A_exp A_EnumExp(A_pos pos, A_expList enumids);
A_exp A_IntdefExp(A_pos pos, A_exp intdef);
A_exp A_FloatdefExp(A_pos pos, A_exp numdigits, A_exp rangeopt);
A_exp A_FixeddefExp(A_pos pos, A_exp delta, A_exp range);
A_exp A_FixeddefdigitExp(A_pos pos, A_exp delta, A_exp numdigits, A_exp rangeopt);
A_exp A_UnconarraydefExp(A_pos pos, A_expList indexs, A_exp subtypeind);
A_exp A_ConarraydefExp(A_pos pos, A_expList iterindex, A_exp subtypeind);
A_exp A_NullrecorddefExp(A_pos pos);
A_exp A_RecorddefExp(A_pos pos, A_expList pragmas, A_exp complist);
A_exp A_Pragma(A_pos pos, string pragmaname);
A_exp A_Pragmalist(A_pos pos, A_exp name, A_expList pragmaargs);
A_exp A_Alternative(A_pos pos, A_expList choices, A_expList stmts);
A_exp A_Case(A_pos pos, A_exp header, A_expList pragmas, A_expList alternatives);
A_exp A_RaiseExp(A_pos pos, A_exp nameopt);
A_exp A_Procedure(A_pos pos, A_exp procedurename);
A_exp A_FunctionUse(A_pos pos, A_exp name, A_expList value);
A_exp A_CompAssoc(A_pos pos, A_expList choices, A_exp expression);
A_exp A_CompUnit(A_pos pos, A_expList contextspec, A_exp privatee, A_exp unit, A_expList pragmas);
A_exp A_Useclause(A_pos pos, A_exp type, A_expList names);
A_exp A_ContextSpecwith(A_pos pos, A_expList withclause, A_expList useclauseopt);
A_exp A_SubprogSpec(A_pos pos, A_exp name, A_expList formalpart);
A_exp A_NameConstr(A_pos pos, A_exp name, A_exp constraint);
A_exp A_DecimalConstr(A_pos pos, A_exp expression, A_exp rangeopt);
A_exp A_IdentExp(A_pos pos, S_symbol ident);
A_exp A_NotImplemented(A_pos pos, string msg);
A_dec A_VarDec(A_pos pos, S_symbol var, S_symbol typ, A_exp init);
A_dec A_GlobalDec(A_pos pos);
A_ty A_NameTy(A_pos pos, S_symbol name);
A_ty A_RecordTy(A_pos pos, A_fieldList record);
A_ty A_ArrayTy(A_pos pos, S_symbol array);
A_ty A_ObjectTy(A_pos pos, string qualifier, A_exp subtype, A_exp init);
A_ty A_NumTy(A_pos pos, A_exp assignexp);
A_ty A_TypeDecTy(A_pos pos,A_expList discrimopt, A_exp typecomp);
A_field A_Field(A_pos pos, S_symbol name, S_symbol typ);
A_fieldList A_FieldList(A_field head, A_fieldList tail);
A_expList A_ExpList(A_exp head, A_expList tail);
A_fundec A_Fundec(A_pos pos, S_symbol name, A_fieldList params, S_symbol result,
		  A_exp body);
A_fundecList A_FundecList(A_fundec head, A_fundecList tail);
A_decList A_DecList(A_dec head, A_decList tail);
A_namety A_Namety(S_symbol name, A_ty ty);
A_nametyList A_NametyList(A_namety head, A_nametyList tail);
A_efield A_Efield(S_symbol name, A_exp exp);
A_efieldList A_EfieldList(A_efield head, A_efieldList tail);
