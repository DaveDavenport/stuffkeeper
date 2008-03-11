#include <glib.h>
#include <gtk/gtk.h>
#include <stdlib.h>

/* Include the database */
#include "stuffkeeper-data-backend.h"
#include "stuffkeeper-interface.h"
#include "bacon-message-connection.h"

GList *interface_list = NULL;

/**
 * Interprocess communication. Used to make sure
 * only one instance is running
 */
BaconMessageConnection *bacon_connection = NULL;

/**
 * Config system
 */
GKeyFile *config_file = NULL;
/**
 * Command line parsing stuff 
 */

static gchar *db_path = NULL;

static GOptionEntry entries[] = 
{
  { "db-path", 'd', 0, G_OPTION_ARG_STRING, &db_path, "Path to the database", "Path" },
  { NULL }
};



/**
 * Handle ipc messages
 */
static void bacon_on_message_received(const char *message, gpointer data)
{
    StuffKeeperDataBackend *skdb = STUFFKEEPER_DATA_BACKEND(data);
    printf("IPC: got '%s'\n", (message)?message:"(null)");
    if(message)
    {
        if(strcmp(message, "New Window") == 0)
        {
            StuffKeeperInterface *ski= stuffkeeper_interface_new();
            interface_list = g_list_append(interface_list, ski);
            stuffkeeper_interface_initialize_interface(ski,skdb);
            printf("IPC: Requested new window\n");
        }
    }
}

/**
 * The main programs
 */

int main ( int argc, char **argv )
{
    GError *error = NULL;
    GOptionContext *context;

    StuffKeeperInterface  *ski;

    /* string used the path*/
    gchar *path;
    gchar *config_path;
    /* pointer holding the backend */
    StuffKeeperDataBackend *skdb = NULL;



    context = g_option_context_new ("- StuffKeeper");
    g_option_context_add_main_entries (context, entries, "stuffkeeper");
    g_option_context_add_group (context, gtk_get_option_group (TRUE));
    g_option_context_parse (context, &argc, &argv, &error);

    /* Initialize gtk */
    if(!gtk_init_check(&argc, &argv))
    {
        /* If we failed to initialize gtk+*/
        /* Tell the user */
        printf("Failed to initialize gtk+\n");
        /* return a failure */
        return EXIT_FAILURE;
    }

    /* Initialize the backend */
    skdb = stuffkeeper_data_backend_new();
    /* Check if creating the backend worked */
    if(!skdb)
    {
        printf("Failed to create a backend\n");
        return EXIT_FAILURE;
    }


    /* Setup the interprocess communication. this does not work in win32! */ 
    bacon_connection = bacon_message_connection_new("stuffkeeper");
    if(bacon_connection) 
    {
        /* Check if we are the only instance, this can be checked by looking if we are the server */
        if (!bacon_message_connection_get_is_server (bacon_connection)) 
        {
            /* There is an instant allready running */
            /* message the running instance, to show a new window */
            bacon_message_connection_send(bacon_connection, "New Window");

            /* Close the connection */
            bacon_message_connection_free (bacon_connection);
            /* Returning */
            printf("There is allready an instance running. quitting\n");
            g_object_unref(skdb); 
            exit(EXIT_SUCCESS);
        }
        /* setup signal handler */
        /* Listen for incoming messages */
        bacon_message_connection_set_callback (bacon_connection,
                bacon_on_message_received,
                skdb);
    }
    else
    {
        /* print an error and quit */
        printf("Failed to setup IPC, quitting\n");
        g_object_unref(skdb); 
        /* Return error code */
        exit(EXIT_FAILURE);
    }


      /**
     * Do filesystem checking 
     */

    /* build the directory where data is stored */
    if(db_path != NULL)
    {
        path = g_build_path(G_DIR_SEPARATOR_S, db_path, NULL);
        printf("Testing path: %s\n", path);

    }
    else
    {
        path = g_build_path(G_DIR_SEPARATOR_S, g_get_home_dir(), ".stuffkeeper", NULL);
    }


    /* Test if the directory exists */
    if(!g_file_test(path, G_FILE_TEST_IS_DIR))
    {
        /* Create the directory if it does not exists */
        if(g_mkdir(path, 0755))
        {
            g_error("Failed to create: %s\n", path);
            return EXIT_FAILURE;
        }
    }


    /* open config file */
    printf("Opening config file\n"); 
    config_file = g_key_file_new();

    config_path = g_build_path(G_DIR_SEPARATOR_S, path, "config.cfg", NULL);
    if(!g_file_test(path, G_FILE_TEST_EXISTS))
    {
        GError *error = NULL;
        if(g_key_file_load_from_file(config_file, config_path, G_KEY_FILE_NONE, &error))
        {
            printf("Failed to load config file\n");
            if(error)
            {
                printf("Reported error: %s\n", error->message);
                g_error_free(error); 
            }
        }
        
    }




    /* Create a main interface */
    ski= stuffkeeper_interface_new();
    interface_list = g_list_append(interface_list, ski);
    stuffkeeper_interface_initialize_interface(ski,skdb);

    /* This tells the backend to populate itself */
    stuffkeeper_data_backend_load(skdb,path);
    /* path */
    g_free(path);

    /* Start the main loop */
    gtk_main();

    g_list_free(interface_list);

    /* cleanup  */
    g_object_unref(skdb);

    /* Close the IPC bus */
    if(bacon_connection)
    {
        bacon_message_connection_free (bacon_connection);
    }
    /* Savin config */
    if(config_path)
    {
        gchar *content = NULL;
        gsize length = 0;
        GError *error = NULL;

        if(g_key_file_to_data(config_file, &length, &error))
        {
            GError *error2 = NULL;
            if(!g_file_set_contents(config_path, content, length, &error2))
            {
                printf("Failed to save file '%s': %s\n", config_path, error2->message);
                g_error_free(error2);
            }
        }
        else
        {
            if(error)
            {
                printf("Failed to serialize config file: %s\n", error->message);
                g_error_free(error);
            }
        }
        /* Free config path */
        g_free(config_path);
    }

    /* exit */
    return EXIT_SUCCESS;
}
