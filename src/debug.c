#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <time.h>
#include "debug.h"
#define RED "\x1b[31;01m"
#define DARKRED "\x1b[31;06m"
#define RESET "\x1b[0m"
#define GREEN "\x1b[32;06m"
#define YELLOW "\x1b[33;06m"


void debug_printf_real(const char *file, const int line, const char *function, const char *format, ...)
{
#ifdef DEBUG
    FILE *out = stdout;
    va_list arglist;

    fprintf(out,""GREEN"DEBUG:"RESET"    %s %s():#%d:\t",file,function,line);
    va_start(arglist,format);
    vfprintf(out,format, arglist);
    if(format[strlen(format)-1] != '\n')
    {
        fprintf(out,"\n");
    }
    fflush(out);
    va_end(arglist);
#endif
}
