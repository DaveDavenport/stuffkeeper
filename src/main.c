#include <gtk/gtk.h>
#include <stdlib.h>

/* Include the database */
#include "stuffkeeper-data-backend.h"

/* Include interface header file */
#include "interface.h"


int main ( int argc, char **argv )
{
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

    /* Initialize the Main interface */
    initialize_interface(skdb);

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


    /* cleanup  */
    g_object_unref(skdb);

    /* exit */
    return EXIT_SUCCESS;
}
