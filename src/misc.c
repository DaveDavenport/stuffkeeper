#include <glib.h>
#include <stdio.h>
#include <string.h>
#include "misc.h"


void open_url(const char *uri)
{
    gchar *data = g_strdup_printf("xdg-open '%s'", uri);
    g_spawn_command_line_async(data, NULL);
    g_free(data);
}
void open_email(const char *uri)
{
    gchar *data = g_strdup_printf("xdg-open 'mailto:%s'", uri);
    g_spawn_command_line_async(data, NULL);
    g_free(data);
}
UrlType url_type(const char *uri)
{
    /* start detecting */
    /* check for http url */
    printf("Checking: %s\n", uri);
    if(g_regex_match_simple("^http://.*", uri, G_REGEX_CASELESS,G_REGEX_MATCH_NOTEMPTY))
    {
        printf("found url\n");
        return URL_HTTP;
    }
    /* check for e-mail adres */
    else if (g_regex_match_simple("^\\w+[\\.\\+\\_\\-\\a-z]*@+\\w+[\\.\\+\\_\\-\\a-z]*.{1}\\w{2,3}.?\\w{2,3}$", uri, G_REGEX_CASELESS,G_REGEX_MATCH_NOTEMPTY))
    {
        printf("found e-mail\n");
        return URL_EMAIL;
    }
    else
    {
        printf("found other\n");
        return URL_OTHER;
    }
}
