#ifndef __MISC_H__
#define __MISC_H__
extern GKeyFile *config_file;


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
#endif
