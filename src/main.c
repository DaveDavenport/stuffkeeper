#include <gtk/gtk.h>
#include <stdlib.h>

/* Include the database */
#include "stuffkeeper-data-backend.h"
/* Include interface header file */
#include "interface.h"


int main ( int argc, char **argv )
{
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

    /* This tells the backend to populate itself */
    stuffkeeper_data_backend_load(skdb);

    /* Start the main loop */
    gtk_main();


    /* cleanup  */
    g_object_unref(skdb);

    /* exit */
    return EXIT_SUCCESS;
}
