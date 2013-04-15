#include <stdio.h>
#include <stdlib.h>
int random1=0;
int newlab(){
	int temp=random1;
	random1++;	
	return temp;
}
	
void codegen(struct codelist * list){
	int opcode;
	FILE *fid = fopen("code.S", "a");
	while(list!=NULL)
	{
		opcode=list->entry->opcode;
		if(opcode==ASSIGNOP){
			if(list->entry->arg1->basictype!=SYMTABENTRY && list->entry->arg1->basictype!=TEMPVARIABLE){
				int off1;
				if(list->entry->arg1->type==TypeInt)
					 off1=list->entry->arg1->value.ival;		
				else if(list->entry->arg1->type==TypeFloat)
					 off1=list->entry->arg1->value.rval;
				int target = list->entry->target->offset;
				fprintf(fid,"\tli  $t1,%d \n", off1);
				fprintf(fid,"\tsw  $t1,%d($sp) \n", -target);	
			}
			else{
				int off1 = list->entry->arg1->offset;
				int target =list->entry->target->offset;
				fprintf(fid,"\tlw  $t1,%d($sp) \n", -off1);
				fprintf(fid,"\tsw  $t1,%d($sp) \n", -target);
			}	
		}	
		else if(opcode==INTADDOP ){
			int off1 = list->entry->arg1->offset;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $t1,%d($sp) \n", -off1);
			fprintf(fid,"\tlw  $t2,%d($sp) \n", -off2);
			fprintf(fid,"\tadd $t3,$t1,$t2 \n");
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);

		}	
		else if(opcode==INTADDOPI ){
			int off1 = list->entry->arg1->offset;
			int off2 = list->entry->arg2->value.ival;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $t1,%d($sp) \n", -off1);
			fprintf(fid,"\tli  $t2,%d \n",off2);
			fprintf(fid,"\tadd $t3,$t1,$t2 \n");
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode==IINTADDOP){			
			int off1 = list->entry->arg1->value.ival;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $t1,%d \n",off1);
			fprintf(fid,"\tlw  $t2,%d($sp) \n",-off2);
			fprintf(fid,"\tadd $t3,$t1,$t2 \n");
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode==IINTADDOPI){			
			int off1 = list->entry->arg1->value.ival;
			int off2 = list->entry->arg2->value.ival;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $t1,%d \n",off1);
			fprintf(fid,"\tli  $t2,%d \n",off2);
			fprintf(fid,"\tadd $t3,$t1,$t2 \n");
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode==REALADDOP ){
			int off1 = list->entry->arg1->offset;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $f1,%d($sp) \n", -off1);
			fprintf(fid,"\tlw  $f2,%d($sp) \n", -off2);
			fprintf(fid,"\tadd $f3,$f1,$f2 \n");
			fprintf(fid,"\tsw  $f3,%d($sp) \n", -target);

		}	
		else if(opcode==REALADDOPI ){
			int off1 = list->entry->arg1->offset;
			int off2 = list->entry->arg2->value.ival;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw.s  $f1,%d($sp) \n", -off1);
			fprintf(fid,"\tli.s  $f2,%f \n",off2);
			fprintf(fid,"\tadd.s $f3,$f1,$f2 \n");
			fprintf(fid,"\tsw.s  $f3,%d($sp) \n", -target);
		}
		else if(opcode==IREALADDOP ){			
			int off1 = list->entry->arg1->value.ival;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $f1,%f \n",off1);
			fprintf(fid,"\tlw  $f2,%d($sp) \n",-off2);
			fprintf(fid,"\tadd $f3,$f1,$f2 \n");
			fprintf(fid,"\tsw  $f3,%d($sp) \n", -target);
		}
		else if(opcode==IREALADDOPI ){			
			int off1 = list->entry->arg1->value.ival;
			int off2 = list->entry->arg2->value.ival;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $f1,%f \n",off1);
			fprintf(fid,"\tli  $f2,%f \n",off2);
			fprintf(fid,"\tadd $f3,$f1,$f2 \n");
			fprintf(fid,"\tsw  $f3,%d($sp) \n", -target);
		}


		else if(opcode==INTSUBOP ){
			int off1 = list->entry->arg1->offset;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $t1,%d($sp) \n", -off1);
			fprintf(fid,"\tlw  $t2,%d($sp) \n", -off2);
			fprintf(fid,"\tsub $t3,$t1,$t2 \n");
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);

		}	
		else if(opcode==INTSUBOPI ){
			int off1 = list->entry->arg1->offset;
			int off2 = list->entry->arg2->value.ival;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $t1,%d($sp) \n", -off1);
			fprintf(fid,"\tli  $t2,%d \n",off2);
			fprintf(fid,"\tsub $t3,$t1,$t2 \n");
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode==IINTSUBOP ){			
			int off1 = list->entry->arg1->value.ival;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $t1,%d \n",off1);
			fprintf(fid,"\tlw  $t2,%d($sp) \n",-off2);
			fprintf(fid,"\tsub $t3,$t1,$t2 \n");
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode==IINTSUBOPI ){			
			int off1 = list->entry->arg1->value.ival;
			int off2 = list->entry->arg2->value.ival;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $t1,%d \n",off1);
			fprintf(fid,"\tli  $t2,%d \n",off2);
			fprintf(fid,"\tsub $t3,$t1,$t2 \n");
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode==REALSUBOP ){
			int off1 = list->entry->arg1->offset;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $f1,%d($sp) \n", -off1);
			fprintf(fid,"\tlw  $f2,%d($sp) \n", -off2);
			fprintf(fid,"\tsub $f3,$f1,$f2 \n");
			fprintf(fid,"\tsw  $f3,%d($sp) \n", -target);

		}	
		else if(opcode==REALSUBOPI ){
			int off1 = list->entry->arg1->offset;
			int off2 = list->entry->arg2->value.ival;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $f1,%d($sp) \n", -off1);
			fprintf(fid,"\tli  $f2,%f \n",off2);
			fprintf(fid,"\tsub $f3,$f1,$f2 \n");
			fprintf(fid,"\tsw  $f3,%d($sp) \n", -target);
		}
		else if(opcode==IREALSUBOP ){			
			int off1 = list->entry->arg1->value.ival;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $f1,%f \n",off1);
			fprintf(fid,"\tlw  $f2,%d($sp) \n",-off2);
			fprintf(fid,"\tsub $f3,$f1,$f2 \n");
			fprintf(fid,"\tsw  $f3,%d($sp) \n", -target);
		}
		else if(opcode==IREALSUBOPI ){			
			int off1 = list->entry->arg1->value.ival;
			int off2 = list->entry->arg2->value.ival;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $f1,%f \n",off1);
			fprintf(fid,"\tli  $f2,%f \n",off2);
			fprintf(fid,"\tsub $f3,$f1,$f2 \n");
			fprintf(fid,"\tsw  $f3,%d($sp) \n", -target);
		}

		else if(opcode==INTMULOP ){
			int off1 = list->entry->arg1->offset;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $t1,%d($sp) \n", -off1);
			fprintf(fid,"\tlw  $t2,%d($sp) \n", -off2);
			fprintf(fid,"\tmul $t3,$t1,$t2 \n");
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);

		}	
		else if(opcode==INTMULOPI ){
			int off1 = list->entry->arg1->offset;
			int off2 = list->entry->arg2->value.ival;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $t1,%d($sp) \n", -off1);
			fprintf(fid,"\tli  $t2,%d \n",off2);
			fprintf(fid,"\tmul $t3,$t1,$t2 \n");
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode==IINTMULOP ){			
			int off1 = list->entry->arg1->value.ival;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $t1,%d \n",off1);
			fprintf(fid,"\tlw  $t2,%d($sp) \n",-off2);
			fprintf(fid,"\tmul $t3,$t1,$t2 \n");
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode==IINTMULOPI ){			
			int off1 = list->entry->arg1->value.ival;
			int off2 = list->entry->arg2->value.ival;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $t1,%d \n",off1);
			fprintf(fid,"\tli  $t2,%d \n",off2);
			fprintf(fid,"\tmul $t3,$t1,$t2 \n");
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode==REALMULOP ){
			int off1 = list->entry->arg1->offset;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $f1,%d($sp) \n", -off1);
			fprintf(fid,"\tli  $f2,%d($sp) \n", -off2);
			fprintf(fid,"\tmul $f3,$f1,$f2 \n");
			fprintf(fid,"\tsw  $f3,%d($sp) \n", -target);

		}	
		else if(opcode==REALMULOPI ){
			int off1 = list->entry->arg1->offset;
			int off2 = list->entry->arg2->value.ival;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $f1,%d($sp) \n", -off1);
			fprintf(fid,"\tlw  $f2,%f \n",off2);
			fprintf(fid,"\tmul $f3,$f1,$f2 \n");
			fprintf(fid,"\tsw  $f3,%d($sp) \n", -target);
		}
		else if(opcode==IREALMULOP ){			
			int off1 = list->entry->arg1->value.ival;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $f1,%f \n",off1);
			fprintf(fid,"\tlw  $f2,%d($sp) \n",-off2);
			fprintf(fid,"\tmul $f3,$f1,$f2 \n");
			fprintf(fid,"\tsw  $f3,%d($sp) \n", -target);
		}
		else if(opcode==IREALMULOPI ){			
			int off1 = list->entry->arg1->value.ival;
			int off2 = list->entry->arg2->value.ival;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $f1,%f \n",off1);
			fprintf(fid,"\tli  $f2,%f \n",off2);
			fprintf(fid,"\tmul $f3,$f1,$f2 \n");
			fprintf(fid,"\tsw  $f3,%d($sp) \n", -target);
		}
		else if(opcode==INTDIVOP ){
			int off1 = list->entry->arg1->offset;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $t1,%d($sp) \n", -off1);
			fprintf(fid,"\tlw  $t2,%d($sp) \n", -off2);
			fprintf(fid,"\tdiv $t3,$t1,$t2 \n");
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);

		}	
		else if(opcode==INTDIVOPI ){
			int off1 = list->entry->arg1->offset;
			int off2 = list->entry->arg2->value.ival;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $t1,%d($sp) \n", -off1);
			fprintf(fid,"\tli  $t2,%d \n",off2);
			fprintf(fid,"\tdiv $t3,$t1,$t2 \n");
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode==IINTDIVOP ){			
			int off1 = list->entry->arg1->value.ival;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $t1,%d \n",off1);
			fprintf(fid,"\tlw  $t2,%d($sp) \n",-off2);
			fprintf(fid,"\tdiv $t3,$t1,$t2 \n");
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode==IINTDIVOPI ){			
			int off1 = list->entry->arg1->value.ival;
			int off2 = list->entry->arg2->value.ival;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $t1,%d \n",off1);
			fprintf(fid,"\tli  $t2,%d \n",off2);
			fprintf(fid,"\tdiv $t3,$t1,$t2 \n");
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode==REALDIVOP ){
			int off1 = list->entry->arg1->offset;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $f1,%d($sp) \n", -off1);
			fprintf(fid,"\tlw  $f2,%d($sp) \n", -off2);
			fprintf(fid,"\tdiv $f3,$f1,$f2 \n");
			fprintf(fid,"\tsw  $f3,%d($sp) \n", -target);

		}	
		else if(opcode==REALDIVOPI ){
			int off1 = list->entry->arg1->offset;
			int off2 = list->entry->arg2->value.ival;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $f1,%d($sp) \n", -off1);
			fprintf(fid,"\tli  $f2,%f \n",off2);
			fprintf(fid,"\tdiv $f3,$f1,$f2 \n");
			fprintf(fid,"\tsw  $f3,%d($sp) \n", -target);
		}
		else if(opcode==IREALDIVOP ){			
			int off1 = list->entry->arg1->value.ival;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $f1,%f \n",off1);
			fprintf(fid,"\tlw  $f2,%d($sp) \n",-off2);
			fprintf(fid,"\tdiv $f3,$f1,$f2 \n");
			fprintf(fid,"\tsw  $f3,%d($sp) \n", -target);
		}
		else if(opcode==IREALDIVOPI ){			
			int off1 = list->entry->arg1->value.ival;
			int off2 = list->entry->arg2->value.ival;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $f1,%f \n",off1);
			fprintf(fid,"\tli  $f2,%f \n",off2);
			fprintf(fid,"\tdiv $f3,$f1,$f2 \n");
			fprintf(fid,"\tsw  $f3,%d($sp) \n", -target);
		}

		else if(opcode == EQUALEQUAL) {
			char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->offset;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $t1,%d($sp) \n", -off1);
			fprintf(fid,"\tlw  $t2,%d($sp) \n", -off2);
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tbeq $t1,$t2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == REQUALEQUAL) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->offset;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $f1,%d($sp) \n", -off1);
			fprintf(fid,"\tlw  $f2,%d($sp) \n", -off2);
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tbeq $f1,$f2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == EQUALEQUALI) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->offset;
			int off2 = list->entry->arg2->value.ival;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $t1,%d($sp) \n",-off1);
			fprintf(fid,"\tli  $t2,%d \n",off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tbeq $t1,$t2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == REQUALEQUALI) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->offset;
			float off2 = list->entry->arg2->value.rval;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $f1,%d($sp) \n",-off1);
			fprintf(fid,"\tli  $f2,%f \n",off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tbeq $f1,$f2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == IEQUALEQUAL) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->value.ival;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $t1,%d \n", off1);
			fprintf(fid,"\tlw  $t2,%d($sp) \n",-off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tbeq $t1,$t2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == IREQUALEQUAL) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            float off1 = list->entry->arg1->value.rval;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $f1,%f \n", off1);
			fprintf(fid,"\tlw  $f2,%d($sp) \n",-off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tbeq $f1,$f2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == IEQUALEQUALI) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->value.ival;
			int off2 = list->entry->arg2->value.ival;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $t1,%d \n", off1);
			fprintf(fid,"\tli  $t2,%d \n", off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tbeq $t1,%$t2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == IREQUALEQUALI) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->value.rval;
			int off2 = list->entry->arg2->value.rval;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $f1,%f \n",off1);
			fprintf(fid,"\tli  $f2,%f \n",off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tbeq $f1,$f2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == LESSTHAN) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->offset;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $t1,%d($sp) \n", -off1);
			fprintf(fid,"\tlw  $t2,%d($sp) \n", -off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tblt $t1,$t2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == RLESSTHAN) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->offset;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $f1,%d($sp) \n", -off1);
			fprintf(fid,"\tlw  $f2,%d($sp) \n", -off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tblt $f1,$f2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == LESSTHANI) {
			//printf("\ncoming here\n");
			char labelfalse[15];int x=0;int y=1;
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->offset;
			int off2 = list->entry->arg2->value.ival;
			int target = list->entry->target->offset;
			
			fprintf(fid,"\tlw  $t1,%d($sp) \n", -off1);
			fprintf(fid,"\tli  $t2,%d \n", off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tblt $t1,$t2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
			//printf("\ncoming here111 %s \n",labelfalse);
		}
		else if(opcode == RLESSTHANI) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->offset;
			float off2 = list->entry->arg2->value.rval;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $f1,%d($sp) \n", -off1);
			fprintf(fid,"\tli  $f2,%f \n", off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tblt $f1,$f2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == ILESSTHAN) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->value.ival;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $t1,%d \n", off1);
			fprintf(fid,"\tlw  $t2,%d($sp) \n",-off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tblt $t1,$t2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == IRLESSTHAN) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            float off1 = list->entry->arg1->value.rval;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $f1,%f \n", off1);
			fprintf(fid,"\tlw  $f2,%d($sp) \n", -off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tblt $f1,$f2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}

		else if(opcode == ILESSTHANI) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->value.ival;
			int off2 = list->entry->arg2->value.ival;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $t1,%d \n", off1);
			fprintf(fid,"\tli  $t2,%d \n", off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tblt $t1,$t2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == IRLESSTHANI) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            float off1 = list->entry->arg1->value.rval;
			float off2 = list->entry->arg2->value.rval;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $f1,%f \n", off1);
			fprintf(fid,"\tli  $f2,%f \n", off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tblt $f1,$f2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == LESSTHANEQ) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->offset;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $t1,%d($sp) \n", -off1);
			fprintf(fid,"\tlw  $t2,%d($sp) \n", -off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tble $t1,$t2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == RLESSTHANEQ) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->offset;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $f1,%d($sp) \n", -off1);
			fprintf(fid,"\tlw  $f2,%d($sp) \n", -off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tble $f1,$f2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == LESSTHANEQI) {
			char labelfalse[15];int x=0;int y=1;
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->offset;
			int off2 = list->entry->arg2->value.ival;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $t1,%d($sp) \n", -off1);
			fprintf(fid,"\tli  $t2,%d \n", off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tble $t1,$t2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == RLESSTHANEQI) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->offset;
			float off2 = list->entry->arg2->value.rval;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $f1,%d($sp) \n", -off1);
			fprintf(fid,"\tli  $f2,%f \n", off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tble $f1,$f2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == ILESSTHANEQ) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->value.ival;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $t1,%d \n", off1);
			fprintf(fid,"\tlw  $t2,%d($sp) \n",-off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tble $t1,$t2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == IRLESSTHANEQ) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            float off1 = list->entry->arg1->value.rval;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $f1,%f \n", off1);
			fprintf(fid,"\tlw  $f2,%d($sp) \n", -off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tble $f1,$f2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}

		else if(opcode == ILESSTHANEQI) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->value.ival;
			int off2 = list->entry->arg2->value.ival;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $t1,%d \n", off1);
			fprintf(fid,"\tli  $t2,%d \n", off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tble $t1,$t2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == ILESSTHANEQI) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            float off1 = list->entry->arg1->value.rval;
			float off2 = list->entry->arg2->value.rval;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $f1,%f \n", off1);
			fprintf(fid,"\tli  $f2,%f \n", off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tble $f1,$f2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == GREATERTHAN) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->offset;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $t1,%d($sp) \n", -off1);
			fprintf(fid,"\tlw  $t2,%d($sp) \n", -off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tbgt $t1,$t2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == RGREATERTHAN) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->offset;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $f1,%d($sp) \n", -off1);
			fprintf(fid,"\tlw  $f2,%d($sp) \n", -off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tbgt $f1,$f2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == GREATERTHANI) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->offset;
			int off2 = list->entry->arg2->value.ival;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $t1,%d($sp) \n", -off1);
			fprintf(fid,"\tli  $t2,%d \n", off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tbgt $t1,$t2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == RGREATERTHANI) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->offset;
			float off2 = list->entry->arg2->value.rval;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $f1,%d($sp) \n", -off1);
			fprintf(fid,"\tli  $f2,%f \n", off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tbgt $f1,$f2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == IGREATERTHAN) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->value.ival;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $t1,%d \n", off1);
			fprintf(fid,"\tlw  $t2,%d($sp) \n", -off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tbgt $t1,$t2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == IRGREATERTHAN) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            float off1 = list->entry->arg1->value.rval;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $f1,%f\n", off1);
			fprintf(fid,"\tlw  $f2,%d($sp) \n", -off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tbgt $f1,$f2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == IGREATERTHANI) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->value.ival;
			int off2 = list->entry->arg2->value.ival;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $t1,%d \n", off1);
			fprintf(fid,"\tli  $t2,%d \n", off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tbgt $t1,$t2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == IRGREATERTHANI) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            float off1 = list->entry->arg1->value.rval;
			float off2 = list->entry->arg2->value.rval;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $f1,%f \n", off1);
			fprintf(fid,"\tli  $f2,%f \n", off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tbgt $f1,$f2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == GREATERTHANEQ) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->value.ival;
			int off2 = list->entry->arg2->value.ival;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $t1,%d($sp) \n", -off1);
			fprintf(fid,"\tlw  $t2,%d($sp) \n", -off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tbge $t1,$t2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == RGREATERTHANEQ) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->value.ival;
			int off2 = list->entry->arg2->value.ival;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $f1,%d($sp) \n", -off1);
			fprintf(fid,"\tlw  $f2,%d($sp) \n", -off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tbge $f1,$f2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == GREATERTHANEQI) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->offset;
			int off2 = list->entry->arg2->value.ival;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $t1,%d($sp) \n", -off1);
			fprintf(fid,"\tli  $t2,%d \n", off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tbge $t1,$t2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == RGREATERTHANEQI) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->offset;
			float off2 = list->entry->arg2->value.rval;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $f1,%d($sp) \n", -off1);
			fprintf(fid,"\tli  $f2,%f \n", off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tbge $f1,$f2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == IGREATERTHANEQ) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->value.ival;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $t1,%d \n", off1);
			fprintf(fid,"\tlw  $t2,%d($sp) \n", -off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tbge $t1,$t2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == IRGREATERTHANEQ) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            float off1 = list->entry->arg1->value.rval;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $f1,%f \n", off1);
			fprintf(fid,"\tlw  $f2,%d($sp) \n",-off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tbge $f1,$f2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == IGREATERTHANEQI) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->value.ival;
			int off2 = list->entry->arg2->value.ival;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $t1,%d \n", off1);
			fprintf(fid,"\tli  $t2,%d \n", off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tbge $t1,%$t2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == IRGREATERTHANEQI) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->value.rval;
			int off2 = list->entry->arg2->value.rval;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $f1,%f \n", off1);
			fprintf(fid,"\tli  $f2,%f \n", off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tbge $f1,$f2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == NOTEQUALO) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->offset;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $t1,%d($sp) \n", -off1);
			fprintf(fid,"\tlw  $t2,%d($sp) \n", -off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tbne $t1,$t2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == RNOTEQUALO) {
			char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->offset;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $f1,%d($sp) \n", -off1);
			fprintf(fid,"\tlw  $f2,%d($sp) \n", -off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tbne $f1,$f2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == NOTEQUALOI) {
			char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->offset;
			int off2 = list->entry->arg2->value.ival;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $t1,%d($sp) \n", -off1);
			fprintf(fid,"\tli  $t2,%d \n", off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tbne $t1,$t2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == RNOTEQUALOI) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->offset;
			float off2 = list->entry->arg2->value.rval;
			int target = list->entry->target->offset;
			fprintf(fid,"\tlw  $f1,%d($sp) \n",-off1);
			fprintf(fid,"\tli  $f2,%f \n", off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tbne $f1,$f2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == INOTEQUALO) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->value.ival;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $t1,%d \n",off1);
			fprintf(fid,"\tlw  $t2,%d($sp) \n",-off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tbne $t1,$t2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == IRNOTEQUALO) {char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            float off1 = list->entry->arg1->value.rval;
			int off2 = list->entry->arg2->offset;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $f1,%f \n", off1);
			fprintf(fid,"\tlw  $f2,%d($sp) \n",-off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tbne $f1,$f2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == INOTEQUALOI) {
			char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            int off1 = list->entry->arg1->value.ival;
			int off2 = list->entry->arg2->value.ival;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $t1,%d \n", off1);
			fprintf(fid,"\tli  $t2,%d \n", off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tbne $t1,%$t2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == IRNOTEQUALOI) {
			char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
            float off1 = list->entry->arg1->value.rval;
			float off2 = list->entry->arg2->value.rval;
			int target = list->entry->target->offset;
			fprintf(fid,"\tli  $f1,%f \n", off1);
			fprintf(fid,"\tli  $f2,%f \n", off2);			
			fprintf(fid,"\tli  $t3,%d \n",1);			
			fprintf(fid,"\tbne $f1,$f2,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		
		else if(opcode == ANDOP){
			char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
			int off1=list->entry->arg1->offset;
			int off2=list->entry->arg2->offset;
			int target=list->entry->target->offset;
			fprintf(fid,"\tlw  $t1,%d($sp) \n", -off1);
			fprintf(fid,"\tlw  $t2,%d($sp) \n", -off2);
			fprintf(fid,"\tli  $t3,%d \n",0);	
			fprintf(fid,"\tbne $t1,$t2,%s \n",labelfalse);
			fprintf(fid,"\tbeq $t1,$t3,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",1);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		}
		else if(opcode == OROP){
			char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
			int off1=list->entry->arg1->offset;
			int off2=list->entry->arg2->offset;
			int target=list->entry->target->offset;
			fprintf(fid,"\tlw  $t1,%d($sp) \n", -off1);
			fprintf(fid,"\tlw  $t2,%d($sp) \n", -off2);
			fprintf(fid,"\tli  $t3,%d \n",1);	
			fprintf(fid,"\tbne $t1,$t2,%s \n",labelfalse);
			fprintf(fid,"\tbeq $t1,$t3,%s \n",labelfalse);
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);
		
		}
		else if(opcode == XOROP){
			char labelfalse[15];
			sprintf(labelfalse,"branchlabel%d",newlabel());
			int off1=list->entry->arg1->offset;
			int off2=list->entry->arg2->offset;
			int target=list->entry->target->offset;
			fprintf(fid,"\tlw  $t1,%d($sp) \n", -off1);
			fprintf(fid,"\tlw  $t2,%d($sp) \n", -off2);
			fprintf(fid,"\tli  $t3,%d \n",1);	
			fprintf(fid,"\tbne $t1,$t2,%s \n",labelfalse);			
			fprintf(fid,"\tli  $t3,%d \n",0);
			fprintf(fid,"\t%s: \n",labelfalse);
			fprintf(fid,"\tsw  $t3,%d($sp) \n", -target);

		}
		else if(opcode == LABELOP){
			fprintf(fid,"\t%s: \n",list->entry->target->name);
		
		}
		else if(opcode == IFEQUALZERO){
			int off1=list->entry->arg1->offset;
			fprintf(fid,"\tli $t1 ,%d\n",0);
			fprintf(fid,"\tlw $t2 ,%d($sp)\n",-off1);
			fprintf(fid,"\tbeq $t2,$t1,%s \n",list->entry->arg2->name);	
		}
		else if(opcode == IFNOTEQUALZERO){
			int off1=list->entry->arg1->offset;
			fprintf(fid,"\tli $t1 ,%d\n",0);
			fprintf(fid,"\tlw $t2 ,%d($sp)\n",-off1);
			fprintf(fid,"\tbne $t2,$t1,%s \n",list->entry->arg2->name);	
		}
		else if(opcode == JUMPTOLABEL){
			fprintf(fid,"\tj %s \n",list->entry->target->name);
		
		}
		
		else if(opcode == DECREMENTSP){
			int off1 = list->entry->arg2->value.ival;
			fprintf(fid,"\tmove $t1,$sp \n");
			fprintf(fid,"\tli  $t2,%d \n", off1);
			fprintf(fid,"\tsub $t3,$t1,$t2 \n");
			fprintf(fid,"\tmove  $sp,$t3\n");
			
		}
		else if(opcode == DECRSPECIAL){
			fprintf(fid,"\tmove $t1,$a1 \n");
			fprintf(fid,"\tli  $t2,%d \n",1);
			fprintf(fid,"\tsub $t3,$t1,$t2 \n");
			fprintf(fid,"\tmove  $a1,$t3\n");
		}
		else if(opcode == INCRSPECIAL){
			fprintf(fid,"\tmove $t1,$a1 \n");
			fprintf(fid,"\tli  $t2,%d \n",1);
			fprintf(fid,"\tadd $t3,$t1,$t2 \n");
			fprintf(fid,"\tmove  $a1,$t3\n");
		}
		else if(opcode == JUMPSPECIAL){
			fprintf(fid,"\tli  $t2,%d \n",0);
			fprintf(fid,"\tbeq $a1,$t2,%s\n",list->entry->target->name);
		}
		else if(opcode	== JUMPANDLINK){
			fprintf(fid,"\tjal %s \n",list->entry->arg1->name);
		}
		else if(opcode == JR){
			fprintf(fid,"\tjr $ra \n");
		}
		else if(opcode == SYSEXIT){
			fprintf(fid,"\tli  $v0,%d \n",10);
			fprintf(fid,"\tsyscall\n");
		}
		else if(opcode == SYSPRINT){
			int off1=list->entry->arg1->offset;
			fprintf(fid,"\tli  $v0,%d \n",1);
			fprintf(fid,"\tlw $a0,%d($sp) \n",-off1);
    			fprintf(fid,"\tsyscall\n");
			fprintf(fid,"\tli $v0, %d \n",11);
			fprintf(fid,"\tli $a0, %d \n",10);
    			fprintf(fid,"\tsyscall\n");
			fprintf(fid,"\tli $v0, %d \n",11);
			fprintf(fid,"\tli $a0, %d \n",10);
    			fprintf(fid,"\tsyscall\n");
		}
		else if(opcode == ARRAYASSIGN1){
			
			int target=list->entry->target->offset;

			if(list->entry->arg1->basictype != SYMTABENTRY && list->entry->arg1->basictype != TEMPVARIABLE )
			{
				fprintf(fid,"\tli  $t1,%d \n",list->entry->arg1->value.ival);
			}
			else
			{
				int off1=list->entry->arg1->offset;
				fprintf(fid,"\tlw  $t1,%d($sp) \n",-off1);
			}
			if(list->entry->arg2->basictype != SYMTABENTRY && list->entry->arg2->basictype != TEMPVARIABLE )
			{
				
				fprintf(fid,"\tli  $t2,%d \n",list->entry->arg2->value.ival);
			}
			else
			{
				int off2=list->entry->arg2->offset;
				fprintf(fid,"\tlw  $t2,%d($sp) \n",-off2);
			}
			
			fprintf(fid,"\tli  $t3,%d \n",4);
			fprintf(fid,"\tmul $t4,$t1,$t3 \n");
			fprintf(fid,"\tsub $t1,$t4,$t3 \n");
			
			fprintf(fid,"\tli  $t3,%d \n",target);
			fprintf(fid,"\tadd $t5,$t3,$t1 \n");

			fprintf(fid,"\tmove  $a3,$sp\n");
			fprintf(fid,"\tsub $t6,$sp,$t5 \n");
			fprintf(fid,"\tmove  $sp,$t6\n");
			fprintf(fid,"\tsw  $t2, %d($sp) \n",0);
			fprintf(fid,"\tmove  $sp,$a3\n");
		}
		else if(opcode == GETNEWTEMP)
		{
			
			int off1=list->entry->arg1->offset;
			int target=list->entry->target->offset;
			if(list->entry->arg2->basictype != SYMTABENTRY && list->entry->arg2->basictype != TEMPVARIABLE )
			{
				
				fprintf(fid,"\tli  $t1,%d \n",list->entry->arg2->value.ival);
				
			}
			else
			{
				int off2=list->entry->arg2->offset;
				fprintf(fid,"\tlw  $t1,%d($sp) \n",-off2); 
			}
			fprintf(fid,"\tli  $t2,%d \n",off1);
			fprintf(fid,"\tli  $t3,%d \n",4);
			fprintf(fid,"\tmul $t4,$t1,$t3 \n");
			fprintf(fid,"\tsub $t1,$t4,$t3 \n");  // offset of index from first element

			fprintf(fid,"\tadd $t3,$t2,$t1 \n");    // total offset from $sp

			fprintf(fid,"\tmove  $a3,$sp\n");
			fprintf(fid,"\tsub $t6,$sp,$t3 \n");
			fprintf(fid,"\tmove  $sp,$t6\n");
			fprintf(fid,"\tlw  $t2, %d($sp) \n",0);
			fprintf(fid,"\tmove  $sp,$a3\n"); 
			fprintf(fid,"\tsw  $t2, %d($sp) \n",-target);
		}
		else if(opcode == SYSPRINTINDEX ){
			int off1=list->entry->arg1->offset;
			if(list->entry->arg2->basictype != SYMTABENTRY && list->entry->arg2->basictype != TEMPVARIABLE )
			{
				
				fprintf(fid,"\tli  $t1,%d \n",list->entry->arg2->value.ival);
				
			}
			else
			{
				int off2=list->entry->arg2->offset;
				fprintf(fid,"\tlw  $t1,%d($sp) \n",-off2); 
			}
			fprintf(fid,"\tli  $t2,%d \n",off1);
			fprintf(fid,"\tli  $t3,%d \n",4);
			fprintf(fid,"\tmul $t4,$t1,$t3 \n");
			fprintf(fid,"\tsub $t1,$t4,$t3 \n");
			fprintf(fid,"\tadd $t3,$t2,$t1 \n");
			fprintf(fid,"\tmove  $a3,$sp\n");
			fprintf(fid,"\tsub $t6,$sp,$t3 \n");
			fprintf(fid,"\tmove  $sp,$t6\n");
			fprintf(fid,"\tlw  $t2, %d($sp) \n",0);
			fprintf(fid,"\tmove  $sp,$a3\n"); 
			fprintf(fid,"\tli  $v0,%d \n",1);
			fprintf(fid,"\tmove $a0,$t2 \n");
			fprintf(fid,"\tsyscall\n");
			fprintf(fid,"\tli $v0, %d \n",11);
			fprintf(fid,"\tli $a0, %d \n",10);
			fprintf(fid,"\tsyscall\n");
		}
		list=list->next;
	}
	fclose(fid);
}


void addheader()
{
	FILE *fid = fopen("code.S", "w");
	 __start:
	fprintf(fid, ".text \n");
	fprintf(fid, " main:\n");
	fclose(fid);
}
void addsequence()
{
	struct genlist* temp=head;
	while(temp!=NULL)
	{
		codegen(temp->entry);
		temp=temp->parent;
	}
}
