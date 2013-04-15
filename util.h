#include <assert.h>

typedef char *string;
typedef char bool;

#define TRUE 1
#define FALSE 0

void *checked_malloc(int);
string String(char *);
string toStrUpper(string);
static int converter(char c);
static string skip(string s);
bool isInt(string);
float FloatBaseConverter(string s);
int IntBaseConverter(string s);
