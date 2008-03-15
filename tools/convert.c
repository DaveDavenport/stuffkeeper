#include <stdio.h>
#include <glib.h>
#include <sqlite3.h>
typedef enum _DbSchemaType {
    DB_SCHEMAS_TYPE_ID = 1,
    DB_SCHEMAS_TYPE_MTIME = 2,
    DB_SCHEMAS_TYPE_CTIME = 3,
    DB_SCHEMAS_TYPE_ICON = 4,
    DB_SCHEMAS_TYPE_NAME = 5

}DbSchemaType;
typedef enum _DbSchemaFieldType {
    DB_SCHEMAS_FIELD_TYPE_ID = 1,
    DB_SCHEMAS_FIELD_TYPE_ORDER = 2,
    DB_SCHEMAS_FIELD_TYPE_TYPE = 3,
    DB_SCHEMAS_FIELD_TYPE_NAME = 4

}DbSchemaFieldType;

typedef enum _DbItemType {
    DB_ITEMS_TYPE_ID = 1,
    DB_ITEMS_TYPE_SCHEMA = 2,
    DB_ITEMS_TYPE_MTIME = 3,
    DB_ITEMS_TYPE_CTIME = 4,
    DB_ITEMS_TYPE_TAG = 5,
    DB_ITEMS_TYPE_NAME = 6

}DbItemType;
typedef enum _DbItemFieldType {
    DB_ITEMS_FIELD_TYPE_ID = 1,
    DB_ITEMS_FIELD_TYPE_TYPE = 3,
    DB_ITEMS_FIELD_TYPE_NAME = 4
}DbItemFieldType;


int main(int argc, char **argv)
{

    /** Tags */
    GDir *dir;

    dir = g_dir_open("./tags", 0,NULL);
    g_chdir("tags");
    char *name;
    while((name = g_dir_read_name(dir)))
    {
        GKeyFile *file = g_key_file_new();
        g_key_file_load_from_file(file, name, G_KEY_FILE_NONE,NULL);
        char *output = sqlite3_mprintf("INSERT INTO 'Tags' "
                "('id','mtime', 'name')"
                "VALUES(%i,%i,%Q);",
                g_key_file_get_integer(file, "general", "id",NULL),
                (int)time(NULL),
                g_key_file_get_string(file, "general","title",NULL));
        printf("%s\n",output);
        sqlite3_free(output);
        g_key_file_free(file);
    }
    g_chdir("../");
    g_dir_close(dir);

    dir = g_dir_open("./schemas", 0,NULL);
    g_chdir("schemas");
    while((name = g_dir_read_name(dir)))                            
    {
        GKeyFile *file = g_key_file_new();
        g_key_file_load_from_file(file, name, G_KEY_FILE_NONE,NULL);
        char *output = sqlite3_mprintf("INSERT INTO 'Schemas' "
                "('SchemaId','type', 'value')"
                "VALUES(%i,%i,%Q);",
                g_key_file_get_integer(file, "general", "id",NULL),
                DB_SCHEMAS_TYPE_ID,
                "-1"); 
        printf("%s\n",output);
        sqlite3_free(output);

        output = sqlite3_mprintf("INSERT INTO 'Schemas' "
                "('SchemaId','type', 'value')"
                "VALUES(%i,%i,%Q);",
                g_key_file_get_integer(file, "general", "id",NULL),
                DB_SCHEMAS_TYPE_NAME,
                g_key_file_get_string(file, "general","title",NULL));
        printf("%s\n",output);
        sqlite3_free(output);

        output = sqlite3_mprintf("INSERT INTO 'Schemas' "
                "('SchemaId','type', 'value')"
                "VALUES(%i,%i,%Q);",
                g_key_file_get_integer(file, "general", "id",NULL),
                DB_SCHEMAS_TYPE_ICON,
                g_key_file_get_string(file, "general","icon",NULL));
        printf("%s\n",output);
        sqlite3_free(output);

        output = sqlite3_mprintf("INSERT INTO 'Schemas' "
                "('SchemaId','type', 'value')"
                "VALUES(%i,%i,%i);",
                g_key_file_get_integer(file, "general", "id",NULL),
                DB_SCHEMAS_TYPE_MTIME,
                time(NULL));
        printf("%s\n",output);
        sqlite3_free(output);


        output = sqlite3_mprintf("INSERT INTO 'Schemas' "
                "('SchemaId','type', 'value') "
                "VALUES(%i,%i,%i);",
                g_key_file_get_integer(file, "general", "id",NULL),
                DB_SCHEMAS_TYPE_CTIME,
                time(NULL));
        printf("%s\n",output);
        sqlite3_free(output);

        gsize length;
        char **fields = g_key_file_get_keys(file, "field-types", &length, NULL);
        int i;
        for(i=0;i<length;i++)
        {
            gchar *temp;
            output = sqlite3_mprintf("INSERT INTO 'SchemasFields' "
                    "('FieldId','SchemaId','type', 'value') "
                    "VALUES(%q,%i,%i,%i);",
                    fields[i],
                    g_key_file_get_integer(file, "general", "id",NULL),
                    DB_SCHEMAS_FIELD_TYPE_ID,
                    -1);
            printf("%s\n",output);
            sqlite3_free(output);


            output = sqlite3_mprintf("INSERT INTO 'SchemasFields' "
                    "('FieldId','SchemaId','type', 'value') "
                    "VALUES(%q,%i,%i,%Q);",
                    fields[i],
                    g_key_file_get_integer(file, "general", "id",NULL),
                    DB_SCHEMAS_FIELD_TYPE_NAME,
                    g_key_file_get_string(file, "field-names",fields[i], NULL) 
                    );
            printf("%s\n",output);
            sqlite3_free(output);

            output = sqlite3_mprintf("INSERT INTO 'SchemasFields' "
                    "('FieldId','SchemaId','type', 'value') "
                    "VALUES(%q,%i,%i,%i);",
                    fields[i],
                    g_key_file_get_integer(file, "general", "id",NULL),
                    DB_SCHEMAS_FIELD_TYPE_ORDER,
                    g_key_file_get_integer(file, "field-sort",fields[i], NULL) 
                    );
            printf("%s\n",output);
            sqlite3_free(output);

            output = sqlite3_mprintf("INSERT INTO 'SchemasFields' "
                    "('FieldId','SchemaId','type', 'value') "
                    "VALUES(%q,%i,%i,%i);",
                    fields[i],
                    g_key_file_get_integer(file, "general", "id",NULL),
                    DB_SCHEMAS_FIELD_TYPE_TYPE,
                    g_key_file_get_integer(file, "field-types",fields[i], NULL) 
                    );
            printf("%s\n",output);
            sqlite3_free(output);

        }
        g_key_file_free(file);
    }
    g_chdir("../");
    g_dir_close(dir);
    /* items */

    dir = g_dir_open("./items", 0,NULL);
    g_chdir("items");
    while((name = g_dir_read_name(dir)))                            
    {
        GKeyFile *file = g_key_file_new();
        g_key_file_load_from_file(file, name, G_KEY_FILE_NONE,NULL);
        char *output = sqlite3_mprintf("INSERT INTO 'Items' "
                "('ItemId','type', 'value')"
                "VALUES(%i,%i,%Q);",
                g_key_file_get_integer(file, "general", "id",NULL),
                DB_ITEMS_TYPE_ID,
                "-1"); 
        printf("%s\n",output);
        sqlite3_free(output);

        output = sqlite3_mprintf("INSERT INTO 'Items' "
                "('ItemId','type', 'value')"
                "VALUES(%i,%i,%Q);",
                g_key_file_get_integer(file, "general", "id",NULL),
                DB_ITEMS_TYPE_NAME,
                g_key_file_get_string(file, "general","title",NULL));
        printf("%s\n",output);
        sqlite3_free(output);

        output = sqlite3_mprintf("INSERT INTO 'Items' "
                "('ItemId','type', 'value')"
                "VALUES(%i,%i,%i);",
                g_key_file_get_integer(file, "general", "id",NULL),
                DB_ITEMS_TYPE_SCHEMA,
                g_key_file_get_integer(file, "general","schema",NULL));
        printf("%s\n",output);
        sqlite3_free(output);

        output = sqlite3_mprintf("INSERT INTO 'Items' "
                "('ItemId','type', 'value')"
                "VALUES(%i,%i,%i);",
                g_key_file_get_integer(file, "general", "id",NULL),
                DB_ITEMS_TYPE_MTIME,
                time(NULL));
        printf("%s\n",output);
        sqlite3_free(output);


        output = sqlite3_mprintf("INSERT INTO 'Items' "
                "('ItemId','type', 'value') "
                "VALUES(%i,%i,%i);",
                g_key_file_get_integer(file, "general", "id",NULL),
                DB_ITEMS_TYPE_CTIME,
                time(NULL));
        printf("%s\n",output);
        sqlite3_free(output);

        gsize length=0;
        char **fields = g_key_file_get_string_list(file, "general","tags", &length, NULL);
        int i;
        for(i=0;i<length;i++)
        {
            output = sqlite3_mprintf("INSERT INTO 'Items' "
                    "('ItemId','type', 'value') "
                    "VALUES(%i,%i,%Q);",
                    g_key_file_get_integer(file, "general", "id",NULL),
                    DB_ITEMS_TYPE_TAG,
                    fields[i]);
            printf("%s\n",output);
            sqlite3_free(output);
        }



        length = 0;
        fields = g_key_file_get_keys(file, "custom", &length, NULL);
       
        {
            GKeyFile *f = g_key_file_new();
            gchar *path = g_strdup_printf("../schemas/%i",g_key_file_get_integer(file, "general","schema",NULL));
            g_key_file_load_from_file(f, path, G_KEY_FILE_NONE, NULL);

            g_free(path);
            for(i=0;i<length;i++)
            {
                gchar *temp;
                if(g_key_file_get_integer(f, "field-types", fields[i], NULL) != 4)
                {
                    output = sqlite3_mprintf("INSERT INTO 'ItemsFields' "
                            "('FieldId','ItemId', 'value') "
                            "VALUES(%q,%i,%Q);",
                            fields[i],
                            g_key_file_get_integer(file, "general", "id",NULL),
                            g_key_file_get_string(file, "custom", fields[i], NULL)
                            );
                    printf("%s\n",output);
                    sqlite3_free(output);
                }else{
                    /* this is a list */

                    gsize len=0;
                    gchar **info;
                    int j;
                    
                    info = g_key_file_get_string_list(file, "custom",fields[i], &len, NULL);
                    for(j=0;j<len;j++)
                    {
                        output = sqlite3_mprintf("INSERT INTO 'ItemsFields' "
                                "('FieldId','ItemId', 'value') "
                                "VALUES(%q,%i,%Q);",
                                fields[i],
                                g_key_file_get_integer(file, "general", "id",NULL),
                                info[j]
                                );
                        printf("%s\n",output);
                        sqlite3_free(output);
                    }
                }

            }
            g_key_file_free(f);
        }
        g_key_file_free(file);
    }
    g_chdir("../");
    g_dir_close(dir);
}
