/*
 * util.c - commonly used utility functions.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "util.h"
void *checked_malloc(int len)
{void *p = malloc(len);
 if (!p) {
    fprintf(stderr,"\nRan out of memory!\n");
    exit(1);
 }
 return p;
}

string String(char *s)
{string p = checked_malloc(strlen(s)+1);
 strcpy(p,s);
 return p;
}

string toStrUpper(string s)
{string p = String(s);
 int i;
 for(i=0;i<strlen(p);i++) p[i] = toupper(p[i]);
 return p;
}

int toNumber(string s)
{
 /* Code for numerals */
 int num =0;
 int i;
 for(i=0;i<strlen(s);i++)
 {
    if(s[i]!='_')
        num = num*10 + (s[i]-'0');
 }
 return num;
}

int converter(char c)
{
	if(c>='0' && c <= '9') return c-'0';
	else if(c>='A' && c<='Z') return c-'A'+10;
	return -1;
}
float FloatBaseConverter(int b, char* n)
{
        int i=0,len=0,dec=0,j,temp,store;
        float ans=0;
        len=strlen(n);
	while(n[i] !='.' && n[i] != '\0')
	{
	        i++;	       
	}
	temp = i;
	j=1;
	for(i=temp+1;i<len;i++)
	{
		if(converter(n[i])>=b || converter(n[i])==-1)
		{ 	        
			return -1;
		}
	        ans=ans+converter(n[i])/pow(b,j);
	        j++;
	}
	j=0;	
	for(i=temp-1;i>=0;i--)
	{
	        if(converter(n[i])>=b || converter(n[i])==-1)
		{
			return -1;
		}
	        ans=ans+converter(n[i])*pow(b,j);
	        j++;
	}
	return ans;
}

int IntBaseConverter(int b, char* n)
{
        int i=0,len=0,dec=0,j,temp,store;
        int ans=0;
        len=strlen(n);
	j=0;	
	for(i=len-1;i>=0;i--)
	{
	        if(converter(n[i])>=b || converter(n[i])==-1)
		{
			return -1;
		}
	        ans=ans+converter(n[i])*pow(b,j);
	        j++;
	}
	return ans;
}
