#ifndef __DEBUG_H__
#define __DEBUG__
/** Internal function, do no use */
void debug_printf_real(const char *file,const int line,const char *function, const char *format,...);
/** 
 * @param dp The debug level the message is at.
 * @param format a printf style string
 * @param ARGS arguments for format
 */
#define debug_printf(format, ARGS...) debug_printf_real(__FILE__,__LINE__,__FUNCTION__,format,##ARGS)


#endif
