/**************Parser for ADA*************/
%{
#include <stdio.h>
#include "util.h"
#include "errormsg.h"
#include "symbol.h"
#include "absyn.h"

int yylex(void); /* function prototype */

A_expList absyn_root;

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

%type <expList> statement_s def_id_s goal_symbol compilation c_name_list
                cond_clause_s else_opt enum_id_s index_s iter_index_constraint
                iter_discrete_range_s variant_s choice_s alternative_s
%type <exp> expression relation simple_expression term factor primary
            literal name allocator qualified parenthesized_primary aggregate
            statement simple_stmt compound_stmt unlabeled null_stmt condition
            range range_constraint simple_name pragma assign_stmt exit_stmt 
            return_stmt goto_stmt procedure_call delay_stmt abort_stmt raise_stmt 
            code_stmt requeue_stmt if_stmt case_stmt loop_stmt block accept_stmt 
            select_stmt def_id pragma_arg_s pragma_arg comp_unit pragma_s
            compound_name unit pkg_body subprog_body subunit case_hdr
            rename_unit cond_part cond_clause init_opt subtype_ind when_opt
            name_opt operator_symbol selected_comp used_char enum_id type_def
            enumeration_type integer_type real_type array_type record_type
            range_spec float_type fixed_type unconstr_array_type
            constr_array_type range_spec_opt index component_subtype_def
            discrete_range record_def comp_list comp_decl_s variant_part_opt
            variant_part comp_decl variant choice discrete_with_range alternative
%type <oper> logical short_circuit relational adding multiplying membership
%type <unaryop> unary
%type <dec> decl object_decl number_decl type_decl subtype_decl subprog_decl
            pkg_decl task_decl prot_decl exception_decl rename_decl generic_decl
            body_stub
%token <oper> LT_EQ EXPON NE GE AND OR XOR MOD REM TICK DOT_DOT
%token <unaryop> NOT ABS
%token <sval> IDENTIFIER CHARACTER STRING

%token NUMBER
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
%token NuLL
%token OF
%token OTHERS
%token OUT
%token PACKAGE
%token PRAGMA
%token PRIVATE
%token PROCEDURE
%token PROTECTED
%token RAISE
%token RANGE
%token RECORD
%token RENAMES
%token REQUEUE
%token RETURN
%token REVERSE
%token SELECT
%token SEPARATE
%token SUBTYPE
%token TAGGED
%token TASK
%token TERMINATE
%token THEN
%token TYPE
%token UNTIL
%token USE
%token WHEN
%token WHILE
%token WITH

%{
%}

%%

goal_symbol : compilation
        {absyn_root = $1;}
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
        {$$ = $1;}
	| number_decl
	    {$$ = $1;}
	| type_decl
	    {$$ = $1;}
	| subtype_decl
	    {$$ = $1;}
	| subprog_decl
	    {$$ = $1;}
	| pkg_decl
	    {$$ = $1;}
	| task_decl
	    {$$ = $1;}
	| prot_decl
	    {$$ = $1;}
	| exception_decl
	    {$$ = $1;}
	| rename_decl
	    {$$ = $1;}
	| generic_decl
	    {$$ = $1;}
	| body_stub
	    {$$ = A_NotImplemented(EM_tokPos,"body_stub not implemented");}
	| error ';'
	    {EM_error(EM_tokPos,"Illegal Declaration.");}
	;

object_decl : def_id_s ':' object_qualifier_opt object_subtype_def init_opt ';'
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
	| ALIASED
	| CONSTANT
	| ALIASED CONSTANT
	;

object_subtype_def : subtype_ind
	| array_type
	;

init_opt :
        {$$ = A_NilExp(EM_tokPos);}
	| IS_ASSIGNED expression
	    {$$ = $2;}
	;

number_decl : def_id_s ':' CONSTANT IS_ASSIGNED expression ';'
	;

type_decl : TYPE IDENTIFIER discrim_part_opt type_completion ';'
	;

discrim_part_opt :
	| discrim_part
	| '(' BOX ')'
	;

type_completion :
	| IS type_def
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
	    {$$ = $1;}
	| access_type
	    {$$ = A_NotImplemented(EM_tokPos,"access type not implemented");}
	| derived_type
	    {$$ = A_NotImplemented(EM_tokPos,"derived type not implemented");}
	| private_type
	    {$$ = A_NotImplemented(EM_tokPos,"private type not implemented");}
	;

subtype_decl : SUBTYPE IDENTIFIER IS subtype_ind ';'
	;

subtype_ind : name constraint
	| name
	    {$$ = $1;}
	;

constraint : range_constraint
	| decimal_digits_constraint
	;

decimal_digits_constraint : DIGITS expression range_constr_opt
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
	| range_constraint
	;

record_type : tagged_opt limited_opt record_def
        {$$ = $3;}
	;

record_def : RECORD pragma_s comp_list END RECORD
        {$$ = A_RecorddefExp(EM_tokPos,$2,$3);}
	| NuLL RECORD
	    {$$ = A_NullrecorddefExp(EM_tokPos);}
	;

tagged_opt :
	| TAGGED
	| ABSTRACT TAGGED
	;

comp_list : comp_decl_s variant_part_opt
        {$$ = A_CompList1(EM_tokPos,$1,$2);}
	| variant_part pragma_s
	    {$$ = A_CompList2(EM_tokPos,$1,$2);}
	| NuLL ';' pragma_s
	    {$$ = A_CompList3(EM_tokPos,$3);}
	;

comp_decl_s : comp_decl
        {$$ = A_CompDecl1(EM_tokPos,$1);}
	| comp_decl_s pragma_s comp_decl
	    {$$ = A_CompDecl2(EM_tokPos,$1,$2,$3);}
	;

variant_part_opt : pragma_s
        {$$ = A_VariantPartOpt1(EM_tokPos,$1);}
	| pragma_s variant_part pragma_s
	    {$$ = A_VariantPartOpt2(EM_tokPos,$1,$2,$3);}
	;

comp_decl : def_id_s ':' component_subtype_def init_opt ';'
	| error ';'
	    {EM_error(EM_tokPos,"Error in comp decl");}
	;

discrim_part : '(' discrim_spec_s ')'
	;

discrim_spec_s : discrim_spec
	| discrim_spec_s ';' discrim_spec
	;

discrim_spec : def_id_s ':' access_opt mark init_opt
	| error
	;

access_opt :
	| ACCESS
	;

variant_part : CASE simple_name IS pragma_s variant_s END CASE ';'
        {$$ = A_VariantPart($2,$4,$5);}
	;

variant_s : variant
        {$$ = A_ExpList($1,NULL);}
	| variant_s variant
	    {$$ = A_ExpList($2,$1);}
	;

variant : WHEN choice_s RIGHT_SHAFT pragma_s comp_list
        {$$ = A_Variant(EM_tokPos,$2,$4,$5);}
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
	    {$$ = A_NotImplemented(EM_tokPos,"indexed name not implemented");}
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
	;

value_s : value
	| value_s ',' value
	;

value : expression
	| comp_assoc
	| discrete_with_range
	| error
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
	| used_char
	| NuLL
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
	| '(' expression ')'
	    {$$ = $2;}
	;

qualified : name TICK parenthesized_primary
        {$$ = A_OpExp(EM_tokPos,A_tickOp,$1,$3);}
	;

allocator : NEW name
	| NEW qualified
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
	    {$$ = A_NotImplemented(EM_tokPos,"procedure not implemented");}
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
	    {$$ = $1;}
	| select_stmt
	    {$$ = $1;}
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
	;

label_opt :
	| IDENTIFIER ':'
	;

iteration :
	| WHILE condition
	| iter_part reverse_opt discrete_range
	;

iter_part : FOR IDENTIFIER IN
	;

reverse_opt :
	| REVERSE
	;

basic_loop : LOOP statement_s END LOOP
	;

id_opt :
	| designator
	;

block : label_opt block_decl block_body END id_opt ';'
	;

block_decl :
	| DECLARE decl_part
	;

block_body : BegiN handled_stmt_s
	;

handled_stmt_s : statement_s except_handler_part_opt 
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
	| FUNCTION designator formal_part_opt RETURN name
	| FUNCTION designator  /* for generic inst and generic rename */
	;

designator : compound_name
	| STRING
	;

formal_part_opt : 
	| formal_part
	;

formal_part : '(' param_s ')'
	;

param_s : param
	| param_s ';' param
	;

param : def_id_s ':' mode mark init_opt
	| error
	;

mode :
	| IN
	| OUT
	| IN OUT
	| ACCESS
	;

subprog_spec_is_push : subprog_spec IS
	;

subprog_body : subprog_spec_is_push
	       decl_part block_body END id_opt ';'
	;

procedure_call : name ';'
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
	| USE TYPE name_s ';'
	;

name_s : name
	| name_s ',' name
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
	| compilation comp_unit
	    { $$ = A_ExpList($2,$1);}
	| pragma pragma_s
	    { $$ = A_ExpList(A_NotImplemented(EM_tokPos,"PRAGMA not implemented"),NULL);}
	;

comp_unit : context_spec private_opt unit pragma_s
	| private_opt unit pragma_s
	    { $$ = $2;}
	;

private_opt :
	| PRIVATE
	;

context_spec : with_clause use_clause_opt
	| context_spec with_clause use_clause_opt
	| context_spec pragma
	;

with_clause : WITH c_name_list ';'
	;

use_clause_opt :
	| use_clause_opt use_clause
	;

unit : pkg_decl
        { $$ = $1;}
	| pkg_body
	    { $$ = $1;}
	| subprog_decl
	    { $$ = $1;}
	| subprog_body
	    { $$ = $1;}
	| subunit
	    { $$ = $1;}
	| generic_decl
	    { $$ = $1;}
	| rename_unit
	    { $$ = $1;}
	;

subunit : SEPARATE '(' compound_name ')'
	      subunit_body
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
        yyparse();
        return 0;
}
