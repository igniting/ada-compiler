/*
 * util.c - commonly used utility functions.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
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

bool isInt(string s)
{ int i;
  for(i=0;i<strlen(s) && s[i]!='.';i++);
  if(i==strlen(s)) return TRUE;
  return FALSE;
}

static string skip(string s)
{ string p = String(s);
  int i,j;
  for(i=0,j=0;s[i];i++) if(s[i]!='_') p[j++]=s[i];
  p[j]='\0';
  return p;
}

static int converter(char c)
{
	if(c>='0' && c <= '9') return c-'0';
	else if(c>='A' && c<='Z') return c-'A'+10;
	return -1;
}

float FloatBaseConverter(string s)
{
    string n = skip(s);
    int i=0,len=0,dec=0,j,temp,store;
    float ans=0.0;
    int b = 0;
    for(i=0;n[i] && n[i]!='#';i++) {b = b*10 + (n[i] - '0');}
    if(!n[i]) b = 10;
    for(i=0;n[i]!='.';i++);
	temp = i;
	j=1;
	for(i=temp+1;n[i] && n[i]!='#';i++)
	{
		if(converter(n[i])>=b || converter(n[i])==-1)
		{ 	        
			return -1;
		}
        ans=ans+converter(n[i])/pow(b,j);
        j++;
	}
	j=0;	
	for(i=temp-1;i>=0 && n[i]!='#';i--)
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

int IntBaseConverter(char* s)
{
    string n = skip(s);
    int i=0,len=0,dec=0,j,temp,store;
    int ans=0;
    int b = 0;
    for(i=0;n[i] && n[i]!='#';i++) b = b*10 + (n[i] - '0');
    if(!n[i]) b = 10;
    len = strlen(n);
    if(n[len-1]=='#') len--;
    i = 0;
	j=0;
	for(i=len-1;i>=0 && n[i]!='#';i--)
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
