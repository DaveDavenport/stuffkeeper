#ifndef __MISC_H__
#define __MISC_H__
/**
 * url to open, uses xdg-open
 */
extern GKeyFile *config_file;
void open_url(const char *uri);
void open_email(const char *uri);

typedef enum _UrlType {
    URL_HTTP,
    URL_EMAIL,
    URL_OTHER
}UrlType;

UrlType url_type(const char *uri);



#endif
