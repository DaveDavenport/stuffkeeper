#ifndef __DEBUG_H__
#define __DEBUG_H__

#ifdef DEBUG
/** Internal function, do no use. Use debug_printf, see below. */
void debug_printf_real(const char *file,const int line,const char *function, const char *format,...);
/** 
 * @param dp The debug level the message is at.
 * @param format a printf style string
 * @param ARGS arguments for format
 */
#define debug_printf(format, ARGS...) debug_printf_real(__FILE__,__LINE__,__FUNCTION__,format,##ARGS)
#else
/* no debug, just do nothing, don't try to do a function call, causing stack calls and all */
#define debug_printf(a,ARGS...) ;

#endif


/* Tic Tac system */
#define TIMER_SUB(start,stop,diff)  diff.tv_usec = stop.tv_usec - start.tv_usec;\
        diff.tv_sec = stop.tv_sec - start.tv_sec;\
        if(diff.tv_usec < 0) {\
            diff.tv_sec -= 1; \
            diff.tv_usec += G_USEC_PER_SEC; \
        }

#define INIT_TIC_TAC() GTimeVal start123, stop123,diff123;\
    g_get_current_time(&start123);

#define TAC(a) g_get_current_time(&stop123);\
    TIMER_SUB(start123, stop123, diff123);\
    printf(a": %lu s, %lu us\n", (unsigned long)( diff123.tv_sec),(unsigned long)( diff123.tv_usec));    

#define TOC(a) TAC(a);\
    start123 = stop123;

#endif
