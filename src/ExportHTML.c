#include <glib.h>
#include <gtk/gtk.h>
#include "stuffkeeper-data-backend.h"
#include "stuffkeeper-data-schema.h"
#include "stuffkeeper-data-item.h"
#include "ExportHTML.h"


void export_item_to_html(StuffKeeperDataItem *item, const char *path, const char *filename)
{
    StuffKeeperDataSchema *schema;
    gchar **fields = NULL;
    gsize length;
    int i;
    gchar *fullpath;
    GError *err = NULL;
    GIOChannel *gio;
    GString *string = g_string_new("");
    gchar *temp;
    /* Open the output file */
    /* build path */
    fullpath = g_build_path(G_DIR_SEPARATOR_S, path, filename, NULL);
    gio = g_io_channel_new_file(fullpath, "w", &err);
    g_free(fullpath);

    if(err)
    {
        printf("Failed to open file: '%s'\n", err->message);
        g_error_free(err);
        return;
    }

    schema = stuffkeeper_data_item_get_schema(item);
    /* */
    if(!schema)
        printf("No schema found\n");

    /* header */
    temp = stuffkeeper_data_item_get_title(item);
    g_string_append_printf(string, "<html>\n\t\t<head>\n\t\t\t<title>%s</title>\n",temp );
    g_string_append(string,
                "\t\t<style type='text/css'>\n"
                "\t\t\tbody { margin: 0px;}\n"
                "\t\t\t#Heading {background: #333; color: #FFF; padding: .3em; margin: 0px; margin-bottom: 2em; }\n"
                "\t\t\t#field { margin: 0px;padding: 0px;}\n"
                "\t\t\t#field  b { 	float: left; text-align: right; display: block; width: 10em;padding-right: 0.3em;}\n"
                "\t\t\t#field lu { float: left;}\n"
                "\t\t</style>"); 
    g_string_append_printf(string, "\t\t</head>\n\t<body>\n");
    g_string_append_printf(string, "<div id='Heading'><H1>%s</H1></div>\n",temp); 
    g_free(temp);

    /* Get fields */
    fields =  stuffkeeper_data_schema_get_fields(schema, &length);
    if(fields) 
    {
        g_string_append(string, "<div id='main'>");
        for(i=0;i< length;i++)
        {
            FieldType type = stuffkeeper_data_schema_get_field_type(schema,fields[i]); 
            g_string_append(string, "<div id='field'>");
            temp = stuffkeeper_data_schema_get_field_name(schema,fields[i]); 
            g_string_append_printf(string, "<b>%s:</b>",temp);
            g_free(temp);

            if(type == FIELD_TYPE_LINK)
            {
               temp = stuffkeeper_data_item_get_string(item, fields[i]);
               if(temp) {
                g_string_append_printf(string, "<a href='%s'>%s</a>",temp,temp);
                g_free(temp);
               }
               else g_string_append(string, "&nbsp;");
            } else if (type == FIELD_TYPE_BOOLEAN) {
                int t = stuffkeeper_data_item_get_boolean(item, fields[i]);
                g_string_append_printf(string, "%s",(t)?"True":"False");
            } else if (type == FIELD_TYPE_IMAGE) {
                const gchar *path1 = stuffkeeper_data_backend_get_path(STUFFKEEPER_DATA_BACKEND(stuffkeeper_data_item_get_backend(item)));
                if(path)
                {
                    gchar *value = g_strdup_printf("%i-%s.jpg", stuffkeeper_data_item_get_id(item),fields[i]); 
                    gchar *fpath = g_build_path(G_DIR_SEPARATOR_S, path1, "images", value,NULL); 
                    gchar *dpath = g_build_path(G_DIR_SEPARATOR_S, path ,value,NULL); 

                    if(fpath)
                    {
                        char *content = NULL;
                        gsize length=0;
                        g_file_get_contents(fpath, &content, &length,NULL);
                        g_file_set_contents(dpath, content, length,NULL);
                        g_string_append_printf(string, "<img src='%s'/>", value);
                        /* free stuff */
                        g_free(content);
                        g_free(fpath);
                    }
                    g_free(value);
                }

            } else if (type == FIELD_TYPE_LIST) {
                gsize len;
                gchar **items =stuffkeeper_data_item_get_list(item, fields[i], &len);
                if(items)
                {
                    int j;
                    g_string_append(string, "<lu>\n");
                    for(j=0;j<len;j++) 
                    {
                        g_string_append_printf(string, "<li>%s</li>\n",items[j]);

                    }
                    g_string_append(string, "</lu>\n");
                    g_strfreev(items);
                }
            } else if (type == FIELD_TYPE_TEXT) {
                temp = stuffkeeper_data_item_get_string(item, fields[i]);
                if(temp) {
                    g_string_append_printf(string, "<p>%s</p>",temp);
                    g_free(temp);
                }
                else g_string_append(string, "&nbsp;");
        }else {
                temp = stuffkeeper_data_item_get_string(item, fields[i]);
                if(temp) {
                    g_string_append_printf(string, "%s",temp);
                    g_free(temp);
                }
                else g_string_append(string, "&nbsp;");
            }
            g_string_append(string, "</div><BR>\n");

        }
        g_string_append(string, "</div>");
        g_strfreev(fields);
    }

    /* close */
    g_string_append(string, "</body></html>");


    g_io_channel_write_chars(gio, string->str, string->len, NULL, NULL);
    g_string_free(string, TRUE);

    g_io_channel_shutdown(gio, TRUE, NULL);
}

