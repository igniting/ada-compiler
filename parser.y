/**************Parser for ADA*************/
%{
#include <stdio.h>
#include "util.h"
#include "errormsg.h"
#include "table.h"
#include "symbol.h"
#include "absyn.h"
#include "prabsyn.h"

int yylex(void); /* function prototype */

A_exp absyn_root;

int yydebug = 0;

S_table table;

void yyerror(char *s)
{
 EM_error(EM_tokPos, "%s", s);
}
%}

%union {
	int pos;
	int ival;
	string sval;
	A_var var;
	A_exp exp;
	A_dec dec;
	A_oper oper;
	A_unaryOper unaryop;
	A_expList expList;
	}

%type <expList> statement_s goal_symbol compilation c_name_list
                cond_clause_s else_opt enum_id_s index_s iter_index_constraint
                iter_discrete_range_s choice_s alternative_s pragma_arg_s pragma_s
                basic_loop handled_stmt_s block_body value_s context_spec with_clause
                name_s use_clause_opt formal_part formal_part_opt param_s def_id_s
                discrim_part_opt discrim_spec_s discrim_part 
%type <exp> expression relation simple_expression term factor primary
            literal name allocator qualified parenthesized_primary 
            statement simple_stmt compound_stmt unlabeled null_stmt condition
            range range_constraint simple_name pragma assign_stmt exit_stmt 
            return_stmt goto_stmt raise_stmt 
            code_stmt if_stmt case_stmt loop_stmt block pragma_arg comp_unit
            compound_name unit subprog_body case_hdr
            cond_part cond_clause subtype_ind when_opt
            name_opt operator_symbol selected_comp used_char enum_id 
            range_spec range_spec_opt index component_subtype_def
            discrete_range choice discrete_with_range alternative iter_part 
            iteration reverse_opt designator id_opt label_opt procedure_call
            indexed_comp value comp_assoc private_opt use_clause subprog_spec
            param def_id decimal_digits_constraint object_subtype_def constraint
            init_opt unconstr_array_type constr_array_type array_type range_constr_opt
            discrim_spec type_completion type_def enumeration_type integer_type
            float_type real_type fixed_type record_def
%type <oper> logical short_circuit relational adding multiplying membership
%type <unaryop> unary
/*******************************************************************************
%type <dec> decl object_decl number_decl type_decl subtype_decl subprog_decl
            pkg_decl task_decl prot_decl exception_decl rename_decl generic_decl
            body_stub
*******************************************************************************/
%type  <sval> object_qualifier_opt
%token <oper> LT_EQ EXPON NE GE AND OR XOR MOD REM TICK DOT_DOT
%token <unaryop> NOT ABS
%token <sval> IDENTIFIER CHARACTER STRING NuLL REVERSE PRIVATE TYPE
%token <ival> NUMBER

%token LT_LT
%token BOX
%token GT_GT
%token IS_ASSIGNED
%token RIGHT_SHAFT
%token ABORT
%token ABSTRACT
%token ACCEPT
%token ACCESS
%token ALIASED
%token ALL
%token ARRAY
%token AT
%token BegiN
%token BODY
%token CASE
%token CONSTANT
%token DECLARE
%token DELAY
%token DELTA
%token DIGITS
%token DO
%token ELSE
%token ELSIF
%token END
%token ENTRY
%token EXCEPTION
%token EXIT
%token FOR
%token FUNCTION
%token GENERIC
%token GOTO
%token IF
%token IN
%token IS
%token LIMITED
%token LOOP
%token NEW
%token OF
%token OTHERS
%token OUT
%token PACKAGE
%token PRAGMA
%token PROCEDURE
%token PROTECTED
%token RAISE
%token RANGE
%token RECORD
%token RENAMES
%token REQUEUE
%token RETURN
%token SELECT
%token SEPARATE
%token SUBTYPE
%token TAGGED
%token TASK
%token TERMINATE
%token THEN
%token UNTIL
%token USE
%token WHEN
%token WHILE
%token WITH

%{
%}

%%

goal_symbol : compilation
        {absyn_root = A_SeqExp(EM_tokPos,$1);}
	;

pragma  : PRAGMA IDENTIFIER ';'
        { $$ = A_Pragma(EM_tokPos,$2);}
	| PRAGMA simple_name '(' pragma_arg_s ')' ';'
	    { $$ = A_Pragmalist(EM_tokPos,$2,$4);}
	;

pragma_arg_s : pragma_arg
        {$$ = A_ExpList($1,NULL);}
	| pragma_arg_s ',' pragma_arg
	    {$$ = A_ExpList($3,$1);}
	;

pragma_arg : expression
        {$$ = $1;}
	| simple_name RIGHT_SHAFT expression
	    {$$ = $1;}
	;

pragma_s :
        {$$ = A_ExpList(A_NilExp(EM_tokPos),NULL);}
	| pragma_s pragma
	    {$$ = A_ExpList($2,$1);}
	;

decl    : object_decl
	| number_decl
	| type_decl
	| subtype_decl
	| subprog_decl
	| pkg_decl
	| task_decl
	| prot_decl
	| exception_decl
	| rename_decl
	| generic_decl
	| body_stub
	| error ';'
	    {EM_error(EM_tokPos,"Illegal Declaration.");}
	;

object_decl : def_id_s ':' object_qualifier_opt object_subtype_def init_opt ';'
        {
            A_expList e = $1;
            while(e!=NULL)
            {   
                if(S_look(table,S_Symbol(e->head->u.stringg))!=NULL)
                {
                    EM_error(EM_tokPos,"Re-declaration of %s",e->head->u.stringg);
                }
                else
                {
                    S_enter(table,S_Symbol(e->head->u.stringg),A_ObjectTy(EM_tokPos,$3,$4,$5));
                }
                e = e->tail;
            }
        }
	;

def_id_s : def_id
        {$$ = A_ExpList($1,NULL);}
	| def_id_s ',' def_id
	    {$$ = A_ExpList($3,$1);}
	;

def_id  : IDENTIFIER
        {$$ = A_StringExp(EM_tokPos,$1);}
	;

object_qualifier_opt :
        {$$ = String("");}
	| ALIASED
	    {$$ = String("ALIASED");}
	| CONSTANT
	    {$$ = String("CONSTANT");}
	| ALIASED CONSTANT
	    {$$ = String("ALIASED_CONSTANT");}
	;

object_subtype_def : subtype_ind
        {$$ = $1;}
	| array_type
	    {$$ = $1;}
	;

init_opt :
        {$$ = A_NilExp(EM_tokPos);}
	| IS_ASSIGNED expression
	    {$$ = $2;}
	;

number_decl : def_id_s ':' CONSTANT IS_ASSIGNED expression ';'
        {
            A_expList e = $1;
            while(e!=NULL)
            {   
                if(S_look(table,S_Symbol(e->head->u.stringg))!=NULL)
                {
                    EM_error(EM_tokPos,"Re-declaration of %s",e->head->u.stringg);
                }
                else
                {
                    S_enter(table,S_Symbol(e->head->u.stringg),A_NumTy(EM_tokPos,$5));
                }
                e = e->tail;
            }
        }
	;

type_decl : TYPE IDENTIFIER discrim_part_opt type_completion ';'
        {
            if(S_look(table,S_Symbol($2))!=NULL)
            {
                EM_error(EM_tokPos,"Re-declaration of %s",$2);
            }
            else
            {
                S_enter(table,S_Symbol($2),A_TypeDecTy(EM_tokPos,$3,$4));
            }
        }
	;

discrim_part_opt :
        {$$ = A_ExpList(A_NilExp(EM_tokPos),NULL);}
	| discrim_part
	    {$$ = $1;}
	| '(' BOX ')'
	    {$$ = A_ExpList(A_StringExp(EM_tokPos,"BOX"),NULL);}
	;

type_completion :
        {$$ = A_NilExp(EM_tokPos);}
	| IS type_def
	    {$$ = $2;}
	;

type_def : enumeration_type
        {$$ = $1;}
	| integer_type
	    {$$ = $1;}
	| real_type
	    {$$ = $1;}
	| array_type
	    {$$ = $1;}
	| record_type
	    {$$ = A_NotImplemented(EM_tokPos,"record type not implemented yet");}
	| access_type
	    {$$ = A_NotImplemented(EM_tokPos,"access type not implemented yet");}
	| derived_type
	    {$$ = A_NotImplemented(EM_tokPos,"derived type not implemented");}
	| private_type
	    {$$ = A_NotImplemented(EM_tokPos,"private type not implemented");}
	;

subtype_decl : SUBTYPE IDENTIFIER IS subtype_ind ';'
	;

subtype_ind : name constraint
        {$$ = A_NameConstr(EM_tokPos,$1,$2);}
	| name
	    {$$ = $1;}
	;

constraint : range_constraint
        {$$ = $1;}
	| decimal_digits_constraint
	    {$$ = $1;}
	;

decimal_digits_constraint : DIGITS expression range_constr_opt
                            {$$ = A_DecimalConstr(EM_tokPos,$2,$3);}
	;

derived_type : NEW subtype_ind
	| NEW subtype_ind WITH PRIVATE
	| NEW subtype_ind WITH record_def
	| ABSTRACT NEW subtype_ind WITH PRIVATE
	| ABSTRACT NEW subtype_ind WITH record_def
	;

range_constraint : RANGE range
        {$$ = $2;}
	;

range : simple_expression DOT_DOT simple_expression
        {$$ = A_OpExp(EM_tokPos,A_rangeOp,$1,$3);}
	| name TICK RANGE
	    {$$ = $1;}
	| name TICK RANGE '(' expression ')'
	    {$$ = $1;}
	;

enumeration_type : '(' enum_id_s ')'
        {$$ = A_EnumExp(EM_tokPos,$2);}

enum_id_s : enum_id
        {$$ = A_ExpList($1,NULL);}
	| enum_id_s ',' enum_id
	    {$$ = A_ExpList($3,$1);}
	;

enum_id : IDENTIFIER
        {$$ = A_StringExp(EM_tokPos,$1);}
	| CHARACTER
	    {$$ = A_StringExp(EM_tokPos,$1);}
	;

integer_type : range_spec
        {$$ = A_IntdefExp(EM_tokPos,$1);}
	| MOD expression
	    {$$ = A_IntdefExp(EM_tokPos,$2);}
	;
	
range_spec : range_constraint
        {$$ = $1;}
	;

range_spec_opt :
        {$$ = A_NilExp(EM_tokPos);}
	| range_spec
	    {$$ = $1;}
	;

real_type : float_type
        {$$ = $1;}
	| fixed_type
	    {$$ = $1;}
	;

float_type : DIGITS expression range_spec_opt
        {$$ = A_FloatdefExp(EM_tokPos,$2,$3);}
	;

fixed_type : DELTA expression range_spec
        {$$ = A_FixeddefExp(EM_tokPos,$2,$3);}
	| DELTA expression DIGITS expression range_spec_opt
	    {$$ = A_FixeddefdigitExp(EM_tokPos,$2,$4,$5);}
	;

array_type : unconstr_array_type
        {$$ = $1;}
	| constr_array_type
	    {$$ = $1;}
	;

unconstr_array_type : ARRAY '(' index_s ')' OF component_subtype_def
        {$$ = A_UnconarraydefExp(EM_tokPos,$3,$6);}
	;

constr_array_type : ARRAY iter_index_constraint OF component_subtype_def
        {$$ = A_ConarraydefExp(EM_tokPos,$2,$4);}
	;

component_subtype_def : aliased_opt subtype_ind
        {$$ = $2;}
	;

aliased_opt : 
	| ALIASED
	;

index_s : index
        {$$ = A_ExpList($1,NULL);}
	| index_s ',' index
	    {$$ = A_ExpList($3,$1);}
	;

index : name RANGE BOX
        {$$ = $1;}
	;

iter_index_constraint : '(' iter_discrete_range_s ')'
        {$$ = $2;}
	;

iter_discrete_range_s : discrete_range
        {$$ = A_ExpList($1,NULL);}
	| iter_discrete_range_s ',' discrete_range
	    {$$ = A_ExpList($3,$1);}
	;

discrete_range : name range_constr_opt
        {$$ = $1;}
	| range
	    {$$ = $1;}
	;

range_constr_opt :
        {$$ = A_NilExp(EM_tokPos);}
	| range_constraint
	    {$$ = $1;}
	;

record_type : tagged_opt limited_opt record_def
	;

record_def : RECORD pragma_s comp_list END RECORD
        {$$ = A_RecorddefExp(EM_tokPos,$2,A_NotImplemented(EM_tokPos,"comp list not implemented"));}
	| NuLL RECORD
	    {$$ = A_NullrecorddefExp(EM_tokPos);}
	;

tagged_opt :
	| TAGGED
	| ABSTRACT TAGGED
	;

comp_list : comp_decl_s variant_part_opt
	| variant_part pragma_s
	| NuLL ';' pragma_s
	;

comp_decl_s : comp_decl
	| comp_decl_s pragma_s comp_decl
	;

variant_part_opt : pragma_s
	| pragma_s variant_part pragma_s
	;

comp_decl : def_id_s ':' component_subtype_def init_opt ';'
	| error ';'
	    {EM_error(EM_tokPos,"Error in comp decl");}
	;

discrim_part : '(' discrim_spec_s ')'
        {$$ = $2;}
	;

discrim_spec_s : discrim_spec
        {$$ = A_ExpList($1,NULL);}
	| discrim_spec_s ';' discrim_spec
	    {$$ = A_ExpList($3,$1);}
	;

discrim_spec : def_id_s ':' access_opt mark init_opt
        {$$ = A_NotImplemented(EM_tokPos,"discrim_spec not implemented");}
	| error
	    {EM_error(EM_tokPos,"Error in discrim_spec");}
	;

access_opt :
	| ACCESS
	;

variant_part : CASE simple_name IS pragma_s variant_s END CASE ';'
	;

variant_s : variant
	| variant_s variant
	;

variant : WHEN choice_s RIGHT_SHAFT pragma_s comp_list
	;

choice_s : choice
	    {$$ = A_ExpList($1,NULL);}
	| choice_s '|' choice
	    {$$ = A_ExpList($3,$1);}
	;

choice : expression
        {$$ = $1;}
	| discrete_with_range
	    {$$ = $1;}
	| OTHERS
	    {$$ = A_StringExp(EM_tokPos,"OTHERS");}
	;

discrete_with_range : name range_constraint
        {$$ = $2;}
	| range
        {$$ = $1;}	
	;

access_type : ACCESS subtype_ind
	| ACCESS CONSTANT subtype_ind
	| ACCESS ALL subtype_ind
	| ACCESS prot_opt PROCEDURE formal_part_opt
	| ACCESS prot_opt FUNCTION formal_part_opt RETURN mark
	;

prot_opt :
	| PROTECTED
	;

decl_part :
	| decl_item_or_body_s1
	;

decl_item_s : 
	| decl_item_s1
	;

decl_item_s1 : decl_item
	| decl_item_s1 decl_item
	;

decl_item : decl
	| use_clause
	| rep_spec
	| pragma
	;

decl_item_or_body_s1 : decl_item_or_body
	| decl_item_or_body_s1 decl_item_or_body
	;

decl_item_or_body : body
	| decl_item
	;

body : subprog_body
	| pkg_body
	| task_body
	| prot_body
	;

name : simple_name
        {$$ = $1;}
	| indexed_comp
	    {$$ = $1;}
	| selected_comp 
	    {$$ = $1;}   
	| attribute
	    {$$ = A_NotImplemented(EM_tokPos,"attribute not implemented");}
	| operator_symbol
	    {$$ = $1;}
	;

mark : simple_name
	| mark TICK attribute_id
	| mark '.' simple_name
	;

simple_name : IDENTIFIER
        {$$ = A_StringExp(EM_tokPos,$1);}
	;

compound_name : simple_name
        { $$ = $1;}
	| compound_name '.' simple_name
	    { $$ = A_OpExp(EM_tokPos,A_dotOp,$1,$3);}
	;

c_name_list : compound_name
        { $$ = A_ExpList($1,NULL);}
	| c_name_list ',' compound_name
	    { $$ = A_ExpList($3,$1);}
	;

used_char : CHARACTER
        { $$ = A_StringExp(EM_tokPos,$1);}
	;

operator_symbol : STRING
        { $$ = A_StringExp(EM_tokPos,$1);}
	;

indexed_comp : name '(' value_s ')'
		{$$ = A_FunctionUse(EM_tokPos,$1,$3);}
	;

value_s : value
	{$$ = A_ExpList($1,NULL);}
	| value_s ',' value
	{$$ = A_ExpList($3,$1);}
	;

value : expression
	{$$ = $1;}
	| comp_assoc
	{$$ = $1;}
	| discrete_with_range
	{$$ = $1;}
	| error
	{EM_error(EM_tokPos,"Error in statement.");}
	;

selected_comp : name '.' simple_name
        {$$ = A_OpExp(EM_tokPos,A_dotOp,$1,$3);}
	| name '.' used_char
	    {$$ = A_OpExp(EM_tokPos,A_dotOp,$1,$3);}
	| name '.' operator_symbol
	    {$$ = A_OpExp(EM_tokPos,A_dotOp,$1,$3);}
	| name '.' ALL
	    {$$ = A_OpExp(EM_tokPos,A_dotOp,$1,A_StringExp(EM_tokPos,"ALL"));}
	;

attribute : name TICK attribute_id
	;

attribute_id : IDENTIFIER
	| DIGITS
	| DELTA
	| ACCESS
	;

literal : NUMBER 
	    {$$ = A_IntExp(EM_tokPos,$1);}
	| used_char
	    {$$ = $1;}
	| NuLL
	    {$$ = A_NilExp(EM_tokPos);}
	;

aggregate : '(' comp_assoc ')'
	| '(' value_s_2 ')'
	| '(' expression WITH value_s ')'
	| '(' expression WITH NuLL RECORD ')'
	| '(' NuLL RECORD ')'
	;

value_s_2 : value ',' value
	| value_s_2 ',' value
	;

comp_assoc : choice_s RIGHT_SHAFT expression
	{$$ = A_CompAssoc(EM_tokPos,$1,$3);}
	;

expression : relation
        {$$ = $1;}
	| expression logical relation
	    {$$ = A_OpExp(EM_tokPos,$2,$1,$3);}
	| expression short_circuit relation
	    {$$ = A_OpExp(EM_tokPos,$2,$1,$3);}
	;

logical : AND
        {$$ = A_andOp;}
	| OR
	    {$$ = A_orOp;}
	| XOR
	    {$$ = A_xorOp;}
	;

short_circuit : AND THEN
        {$$ = $1;}
	| OR ELSE
	    {$$ = $1;}
	;

relation : simple_expression
        {$$ = $1;}
	| simple_expression relational simple_expression
	    {$$ = A_OpExp(EM_tokPos,$2,$1,$3);}
	| simple_expression membership range
	    {$$ = A_OpExp(EM_tokPos,$2,$1,$3);}
	| simple_expression membership name
	    {$$ = A_OpExp(EM_tokPos,$2,$1,$3);}
	;

relational : '='
        {$$ = A_eqOp;}
	| NE
	    {$$ = A_neqOp;}
	| '<'
	    {$$ = A_ltOp;}
	| LT_EQ
	    {$$ = A_leOp;}
	| '>'
	    {$$ = A_gtOp;}
	| GE
	    {$$ = A_geOp;}
	;

membership : IN
        {$$ = A_inOp;}
	| NOT IN
	    {$$ = A_notInOp;}
	;

simple_expression : unary term
        {$$ = A_UnaryOpExp(EM_tokPos,$1,$2);}
	| term
	    {$$ = $1;}
	| simple_expression adding term
	    {$$ = A_OpExp(EM_tokPos,$2,$1,$3);}
	;

unary   : '+'
        {$$ = A_unaryplusOp;}
	| '-'
	    {$$ = A_unaryminusOp;}
	;

adding  : '+'
        {$$ = A_plusOp;}
	| '-'
	    {$$ = A_minusOp;}
	| '&'
	    {$$ = A_binAndOp;}
	;

term    : factor
        {$$ = $1;}
	| term multiplying factor
	    {$$ = A_OpExp(EM_tokPos,$2,$1,$3);}
	;

multiplying : '*'
        {$$ = A_timesOp;}
	| '/'
	    {$$ = A_divideOp;}
	| MOD
	    {$$ = A_modOp;}
	| REM
	    {$$ = A_remOp;}
	;

factor : primary
        {$$ = $1;}
	| NOT primary
	    {$$ = A_UnaryOpExp(EM_tokPos,A_notOp,$2);}
	| ABS primary
	    {$$ = A_UnaryOpExp(EM_tokPos,A_absOp,$2);}
	| primary EXPON primary
	    {$$ = A_OpExp(EM_tokPos,$2,$1,$3);}
	;

primary : literal
        {$$ = $1;}
	| name
	    {$$ = $1;}
	| allocator
	    {$$ = $1;}
	| qualified
	    {$$ = $1;}
	| parenthesized_primary
	    {$$ = $1;}
	;

parenthesized_primary : aggregate
		{$$ = A_NotImplemented(EM_tokPos,"aggregate not implemented");}
	| '(' expression ')'
	    {$$ = $2;}
	;

qualified : name TICK parenthesized_primary
        {$$ = A_OpExp(EM_tokPos,A_tickOp,$1,$3);}
	;

allocator : NEW name 
	    {$$ = $2;}
	| NEW qualified
	    {$$ = $2;}
	;

statement_s : statement
        {$$ = A_ExpList($1,NULL);}
	| statement_s statement
	    {$$ = A_ExpList($2,$1);}
	;

statement : unlabeled
        {$$ = $1;}
	| label statement
	    {$$ = $2;}
	;

unlabeled : simple_stmt
        {$$ = $1;}
	| compound_stmt
	    {$$ = $1;}
	| pragma
	    {$$ = $1;}
	;

simple_stmt : null_stmt
        {$$ = $1;}
	| assign_stmt
	    {$$ = $1;}
	| exit_stmt
	    {$$ = $1;}
	| return_stmt
	    {$$ = $1;}
	| goto_stmt
	    {$$ = $1;}
	| procedure_call
	    {$$ = $1;}
	| delay_stmt
	    {$$ = A_NotImplemented(EM_tokPos,"delay not implemented");}
	| abort_stmt
	    {$$ = A_NotImplemented(EM_tokPos,"abort not implemented");}
	| raise_stmt
	    {$$ = $1;}
	| code_stmt
	    {$$ = $1;}
	| requeue_stmt
	    {$$ = A_NotImplemented(EM_tokPos,"requeue not implemented");}
	| error ';'
	    {EM_error(EM_tokPos,"Error in statement.");}
	;

compound_stmt : if_stmt
        {$$ = $1;}
	| case_stmt
	    {$$ = $1;}
	| loop_stmt
	    {$$ = $1;}
	| block
	    {$$ = $1;}
	| accept_stmt
	    {$$ = A_NotImplemented(EM_tokPos,"accept stmt not implemented");}
	| select_stmt
	    {$$ = A_NotImplemented(EM_tokPos,"select stmt not implemented");}
	;

label : LT_LT IDENTIFIER GT_GT
	;

null_stmt : NuLL ';'
        {$$ = A_NilExp(EM_tokPos);}
	;

assign_stmt : name IS_ASSIGNED expression ';'
	;

if_stmt : IF cond_clause_s else_opt END IF ';'
        {$$ = A_IfExp(EM_tokPos,$2,$3);}
	;

cond_clause_s : cond_clause
        {$$ = A_ExpList($1,NULL);}
	| cond_clause_s ELSIF cond_clause
	    {$$ = A_ExpList($3,$1);}
	;

cond_clause : cond_part statement_s
        {$$ = A_CondExp(EM_tokPos,$1,$2);}
	;

cond_part : condition THEN
        {$$ = $1;}
	;

condition : expression
        {$$ = $1;}
	;

else_opt :
        {$$ = A_ExpList(A_NilExp(EM_tokPos),NULL);}
	| ELSE statement_s
	    {$$ = $2;}
	;

case_stmt : case_hdr pragma_s alternative_s END CASE ';'
        {$$ = A_Case(EM_tokPos,$1,$2,$3);}
	;

case_hdr : CASE expression IS
        {$$ = $2;}
	;

alternative_s :
        {$$ = A_ExpList(A_NilExp(EM_tokPos),NULL);}
	| alternative_s alternative
	    {$$ = A_ExpList($2,$1);}
	;

alternative : WHEN choice_s RIGHT_SHAFT statement_s
        {$$ = A_Alternative(EM_tokPos,$2,$4);}
	;

loop_stmt : label_opt iteration basic_loop id_opt ';'
		{$$ = A_LoopExp(EM_tokPos,$1,$2,$3,$4);}
	;

label_opt :
		{$$ = A_NilExp(EM_tokPos);}
	| IDENTIFIER ':'
		{$$ = A_StringExp(EM_tokPos,$1);}
	;

iteration :
	    {$$ = A_NilExp(EM_tokPos);}
	| WHILE condition
	    {$$ = A_WhileExp(EM_tokPos,$2);}
	| iter_part reverse_opt discrete_range
	    {$$ = A_ForExp(EM_tokPos,$1,$2,$3);}
	;

iter_part : FOR IDENTIFIER IN
	    {$$ = A_StringExp(EM_tokPos,$2);}
	;

reverse_opt :
	    {$$ = A_NilExp(EM_tokPos);}
	| REVERSE
	    {$$ = A_StringExp(EM_tokPos,$1);}
	;

basic_loop : LOOP statement_s END LOOP
	    {$$ = $2;}
	;

id_opt :
		{$$ = A_NilExp(EM_tokPos);}
	| designator
		{$$ = $1;}
	;

block : label_opt
        {S_beginScope(table);S_enter(table,S_Symbol($1->u.stringg),$1);} 
        block_decl
        block_body END
        id_opt
        {
            if($1->kind == A_stringExp)
            {
                if(S_look(table,S_Symbol($6->u.stringg)) == NULL)
                    EM_error(EM_tokPos,"Wrong block id");
            }
        }
        ';'
        {S_endScope(table);}
	;

block_decl :
	| DECLARE decl_part
	;

block_body : BegiN handled_stmt_s
        {$$ = $2;}
	;

handled_stmt_s : statement_s except_handler_part_opt 
        {$$ = $1;}
	; 

except_handler_part_opt :
	| except_handler_part
	;

exit_stmt : EXIT name_opt when_opt ';'
        {$$ = A_ExitExp(EM_tokPos,$2,$3);}
	;

name_opt :
        {$$ = A_NilExp(EM_tokPos);}
	| name
	    {$$ = $1;}
	;

when_opt :
        {$$ = A_NilExp(EM_tokPos);}
	| WHEN condition
	    {$$ = $2;}
	;

return_stmt : RETURN ';'
        {$$ = A_ReturnExp(EM_tokPos,A_NilExp(EM_tokPos));}
	| RETURN expression ';'
	    {$$ = A_ReturnExp(EM_tokPos,$2);}
	;

goto_stmt : GOTO name ';'
        {$$ = A_GotoExp(EM_tokPos,$2);}
	;

subprog_decl : subprog_spec ';'
	| generic_subp_inst ';'
	| subprog_spec_is_push ABSTRACT ';'
	;

subprog_spec : PROCEDURE compound_name formal_part_opt
        {$$ = A_SubprogSpec(EM_tokPos,$2,$3);}
	| FUNCTION designator formal_part_opt RETURN name
	    {$$ = A_NotImplemented(EM_tokPos,"functions not implemented");}
	| FUNCTION designator  /* for generic inst and generic rename */
	    {$$ = A_NotImplemented(EM_tokPos,"functions not implemented");}
	;

designator : compound_name
		{$$ = $1;}
	| STRING
		{$$ = A_StringExp(EM_tokPos,$1);}
	;

formal_part_opt :
        {$$ = A_ExpList(A_NilExp(EM_tokPos),NULL);} 
	| formal_part
	    {$$ = $1;}
	;

formal_part : '(' param_s ')'
        {$$ = $2;}
	;

param_s : param
        {$$ = A_ExpList($1,NULL);}
	| param_s ';' param
	    {$$ = A_ExpList($3,$1);}
	;

param : def_id_s ':' mode mark init_opt
        {$$ = A_NotImplemented(EM_tokPos,"param not implemented");}
	| error
	    {EM_error(EM_tokPos,"Error in parsing param");}
	;

mode :
	| IN
	| OUT
	| IN OUT
	| ACCESS
	;

subprog_spec_is_push : subprog_spec IS
	;

subprog_body : subprog_spec_is_push decl_part block_body END id_opt ';'
	    {$$ = A_SeqExp(EM_tokPos,$3);}
	;

procedure_call : name ';'
        {$$ = A_Procedure(EM_tokPos,$1);}
	;

pkg_decl : pkg_spec ';'
	| generic_pkg_inst ';'
	;

pkg_spec : PACKAGE compound_name IS 
	     decl_item_s private_part END c_id_opt
	;

private_part :
	| PRIVATE decl_item_s
	;

c_id_opt : 
	| compound_name
	;

pkg_body : PACKAGE BODY compound_name IS
	       decl_part body_opt END c_id_opt ';' 
	;

body_opt :
	| block_body
	;

private_type : tagged_opt limited_opt PRIVATE
	;

limited_opt :
	| LIMITED
	;

use_clause : USE name_s ';'
	{$$ = A_Useclause(EM_tokPos,A_NilExp(EM_tokPos),$2);}
	| USE TYPE name_s ';'
	{$$ = A_Useclause(EM_tokPos,A_StringExp(EM_tokPos,$2),$3);}
	;

name_s : name
	{$$ = A_ExpList($1,NULL);}
	| name_s ',' name
	{$$ = A_ExpList($3,$1);}
	;

rename_decl : def_id_s ':' object_qualifier_opt subtype_ind renames ';'
	| def_id_s ':' EXCEPTION renames ';'
	| rename_unit
	;

rename_unit : PACKAGE compound_name renames ';'
	| subprog_spec renames ';'
	| generic_formal_part PACKAGE compound_name renames ';'
	| generic_formal_part subprog_spec renames ';'
	;

renames : RENAMES name
	;

task_decl : task_spec ';'
	;

task_spec : TASK simple_name task_def
	| TASK TYPE simple_name discrim_part_opt task_def
	;

task_def :
	| IS entry_decl_s rep_spec_s task_private_opt END id_opt
	;

task_private_opt :
	| PRIVATE entry_decl_s rep_spec_s
	;

task_body : TASK BODY simple_name IS
	       decl_part block_body END id_opt ';'
	;

prot_decl : prot_spec ';'
	;

prot_spec : PROTECTED IDENTIFIER prot_def
	| PROTECTED TYPE simple_name discrim_part_opt prot_def
	;

prot_def : IS prot_op_decl_s prot_private_opt END id_opt
	;

prot_private_opt :
	| PRIVATE prot_elem_decl_s 


prot_op_decl_s : 
	| prot_op_decl_s prot_op_decl
	;

prot_op_decl : entry_decl
	| subprog_spec ';'
	| rep_spec
	| pragma
	;

prot_elem_decl_s : 
	| prot_elem_decl_s prot_elem_decl
	;

prot_elem_decl : prot_op_decl | comp_decl ;

prot_body : PROTECTED BODY simple_name IS
	       prot_op_body_s END id_opt ';'
	;

prot_op_body_s : pragma_s
	| prot_op_body_s prot_op_body pragma_s
	;

prot_op_body : entry_body
	| subprog_body
	| subprog_spec ';'
	;

entry_decl_s : pragma_s
	| entry_decl_s entry_decl pragma_s
	;

entry_decl : ENTRY IDENTIFIER formal_part_opt ';'
	| ENTRY IDENTIFIER '(' discrete_range ')' formal_part_opt ';'
	;

entry_body : ENTRY IDENTIFIER formal_part_opt WHEN condition entry_body_part
	| ENTRY IDENTIFIER '(' iter_part discrete_range ')' 
		formal_part_opt WHEN condition entry_body_part
	;

entry_body_part : ';'
	| IS decl_part block_body END id_opt ';'
	;

rep_spec_s :
	| rep_spec_s rep_spec pragma_s
	;

entry_call : procedure_call
	;

accept_stmt : accept_hdr ';'
	| accept_hdr DO handled_stmt_s END id_opt ';'
	;

accept_hdr : ACCEPT entry_name formal_part_opt
	;

entry_name : simple_name
	| entry_name '(' expression ')'
	;

delay_stmt : DELAY expression ';'
	| DELAY UNTIL expression ';'
	;

select_stmt : select_wait
	| async_select
	| timed_entry_call
	| cond_entry_call
	;

select_wait : SELECT guarded_select_alt or_select else_opt
	      END SELECT ';'
	;

guarded_select_alt : select_alt
	| WHEN condition RIGHT_SHAFT select_alt
	;

or_select :
	| or_select OR guarded_select_alt
	;

select_alt : accept_stmt stmts_opt
	| delay_stmt stmts_opt
	| TERMINATE ';'
	;

delay_or_entry_alt : delay_stmt stmts_opt
	| entry_call stmts_opt

async_select : SELECT delay_or_entry_alt
	       THEN ABORT statement_s
	       END SELECT ';'
	;

timed_entry_call : SELECT entry_call stmts_opt 
		   OR delay_stmt stmts_opt
	           END SELECT ';'
	;

cond_entry_call : SELECT entry_call stmts_opt 
		  ELSE statement_s
	          END SELECT ';'
	;

stmts_opt :
	| statement_s
	;

abort_stmt : ABORT name_s ';'
	;

compilation :
	    { $$ = A_ExpList(A_NilExp(EM_tokPos),NULL);}
	| compilation comp_unit
	    { $$ = A_ExpList($2,$1);}
	| pragma pragma_s
	    { $$ = A_ExpList(A_NotImplemented(EM_tokPos,"PRAGMA not implemented"),NULL);}
	;

comp_unit : context_spec private_opt unit pragma_s
	    { $$ = A_CompUnit(EM_tokPos,$1, $2, $3, $4);}
	| private_opt unit pragma_s
	    { $$ = A_CompUnit(EM_tokPos, A_ExpList(A_NilExp(EM_tokPos),NULL), $1, $2, $3);}
	;

private_opt :
 	{$$ = A_NilExp(EM_tokPos);}
	| PRIVATE
	{$$ = A_StringExp(EM_tokPos,$1);}
	;

context_spec : with_clause use_clause_opt
	{$$ = A_ExpList(A_ContextSpecwith(EM_tokPos,$1,$2),NULL);}
	| context_spec with_clause use_clause_opt
	{$$ = A_ExpList(A_ContextSpecwith(EM_tokPos,$2,$3),$1);}
	| context_spec pragma
	{$$ = A_ExpList($2, $1);}
	;

with_clause : WITH c_name_list ';'
		{$$ = $2;}
	;

use_clause_opt :
	{$$ = A_ExpList(A_NilExp(EM_tokPos),NULL);}
	| use_clause_opt use_clause
	{$$ = A_ExpList($2,$1);}
	;

unit : pkg_decl
	    {$$ = A_NotImplemented(EM_tokPos,"pkg decl not implemented");}
	| pkg_body
	    {$$ = A_NotImplemented(EM_tokPos,"pkg body not implemented");}
	| subprog_decl
	    {$$ = A_NotImplemented(EM_tokPos,"can not declare subprog here");}
	| subprog_body
	    {$$ = $1;}
	| subunit
	    { $$ = A_NotImplemented(EM_tokPos,"subunit not implemented");}
	| generic_decl
	    {$$ = A_NotImplemented(EM_tokPos,"generic decl not implemented");}
	| rename_unit
	    {$$ = A_NotImplemented(EM_tokPos,"rename unit not implemented");}
	;

subunit : SEPARATE '(' compound_name ')' subunit_body
	;

subunit_body : subprog_body
	| pkg_body
	| task_body
	| prot_body
	;

body_stub : TASK BODY simple_name IS SEPARATE ';'
	| PACKAGE BODY compound_name IS SEPARATE ';'
	| subprog_spec IS SEPARATE ';'
	| PROTECTED BODY simple_name IS SEPARATE ';'
	;

exception_decl : def_id_s ':' EXCEPTION ';'
	;

except_handler_part : EXCEPTION exception_handler
	| except_handler_part exception_handler
	;

exception_handler : WHEN except_choice_s RIGHT_SHAFT statement_s
	| WHEN IDENTIFIER ':' except_choice_s RIGHT_SHAFT statement_s
	;

except_choice_s : except_choice
	| except_choice_s '|' except_choice
	;

except_choice : name
	| OTHERS
	;

raise_stmt : RAISE name_opt ';'
		{$$ = A_RaiseExp(EM_tokPos,$2);}
	;

requeue_stmt : REQUEUE name ';'
	| REQUEUE name WITH ABORT ';'
	;

generic_decl : generic_formal_part subprog_spec ';'
	| generic_formal_part pkg_spec ';'
	;

generic_formal_part : GENERIC
	| generic_formal_part generic_formal
	;

generic_formal : param ';'
	| TYPE simple_name generic_discrim_part_opt IS generic_type_def ';'
	| WITH PROCEDURE simple_name 
	    formal_part_opt subp_default ';'
	| WITH FUNCTION designator 
	    formal_part_opt RETURN name subp_default ';'
	| WITH PACKAGE simple_name IS NEW name '(' BOX ')' ';'
	| WITH PACKAGE simple_name IS NEW name ';'
	| use_clause
	;

generic_discrim_part_opt :
	| discrim_part
	| '(' BOX ')'
	;

subp_default :
	| IS name
	| IS BOX
	;

generic_type_def : '(' BOX ')'
	| RANGE BOX
	| MOD BOX
	| DELTA BOX
	| DELTA BOX DIGITS BOX
	| DIGITS BOX
	| array_type
	| access_type
	| private_type
	| generic_derived_type
	;

generic_derived_type : NEW subtype_ind
	| NEW subtype_ind WITH PRIVATE
	| ABSTRACT NEW subtype_ind WITH PRIVATE
	;

generic_subp_inst : subprog_spec IS generic_inst
	;

generic_pkg_inst : PACKAGE compound_name IS generic_inst
	;

generic_inst : NEW name
	;

rep_spec : attrib_def
	| record_type_spec
	| address_spec
	;

attrib_def : FOR mark USE expression ';'
	;

record_type_spec : FOR mark USE RECORD align_opt comp_loc_s END RECORD ';'
	;

align_opt :
	| AT MOD expression ';'
	;

comp_loc_s :
	| comp_loc_s mark AT expression RANGE range ';'
	;

address_spec : FOR mark USE AT expression ';'
	;

code_stmt : qualified ';'
	;

%%

main() {
        table = S_empty();
        yyparse();
        //pr_exp(stdout,absyn_root,1);
        return 0;
}
