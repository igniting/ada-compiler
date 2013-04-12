#include <assert.h>

typedef char *string;
typedef char bool;

#define TRUE 1
#define FALSE 0

void *checked_malloc(int);
string String(char *);
string toStrUpper(string);
int toNumber(string);
int converter(char c);
float FloatBaseConverter(int b, char* n);
int IntBaseConverter(int b, char* n);
