#ifndef __MISC_H__
#define __MISC_H__
extern GKeyFile *config_file;

#ifdef DEBUG_TIMING
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
    g_debug(a": %lu s, %lu us", (unsigned long)( diff123.tv_sec),(unsigned long)( diff123.tv_usec));    

#define TOC(a) TAC(a);\
    start123 = stop123;

#else // DEBUG_TIMING


#define INIT_TIC_TAC() ;
#define TAC(a) ;
#define TOC(a) ;

#endif // DEBUG_TIMING

/**
 * @param uri   The http url to open.
 *
 * Opens a http:// url using xdg-open
 */
void open_url(const char *uri);

/**
 * @param uri   The http url to open.
 *
 * Opens a e-mail addres using xdg-open by adding mailto: to it.
 */
void open_email(const char *uri);

/**
 * Type of uri.
 */
typedef enum _UrlType {
    /** A http:// uri */
    URL_HTTP,
    /** A vaid e-mail uri*/
    URL_EMAIL,
    /** The rest */
    URL_OTHER
}UrlType;

/** 
 * @param uri The uri to parse.
 *
 * Parses the uri and determens the type.
 *
 * @returns the #UrlType of the uri
 */
UrlType url_type(const char *uri);



void screenshot_add_shadow (GdkPixbuf **src);
void screenshot_add_border (GdkPixbuf **src);

void file_chooser_enable_image_preview(GtkWidget *fc, int size);
GdkPixbuf * gdk_pixbuf_new_from_file_at_max_size(const char *uri, int size);

#endif
