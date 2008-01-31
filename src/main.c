#include <gtk/gtk.h>
#include <stdlib.h>

/* Include the database */
#include "stuffkeeper-data-backend.h"
#include "stuffkeeper-interface.h"

GList *interface_list = NULL;

/* Iter function from g_list_foreach */
static void destroy_interface(gpointer data, gpointer user_data)
{
    gtk_widget_destroy(GTK_WIDGET(data));
}
/**
 * The main programs
 */

int main ( int argc, char **argv )
{
    StuffKeeperInterface  *ski;

    /* string used the path*/
    gchar *path;
    /* pointer holding the backend */
    StuffKeeperDataBackend *skdb = NULL;

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

 
    ski= stuffkeeper_interface_new();
    interface_list = g_list_append(interface_list, ski);
    stuffkeeper_interface_initialize_interface(ski,skdb);

    /**
     * Do filesystem checking 
     */

    /* build the directory where data is stored */
    path = g_build_path(G_DIR_SEPARATOR_S, g_get_home_dir(), ".stuffkeeper", NULL);

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

    /* This tells the backend to populate itself */
    stuffkeeper_data_backend_load(skdb,path);
    /* path */
    g_free(path);

    /* Start the main loop */
    gtk_main();

//    g_list_foreach(interface_list, destroy_interface, NULL);
    g_list_free(interface_list);

    /* cleanup  */
    g_object_unref(skdb);

    /* exit */
    return EXIT_SUCCESS;
}
