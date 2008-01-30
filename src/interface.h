#ifndef __INTERFACE_H__
#define __INTERFACE_H__
/* Include the database */
#include "stuffkeeper-data-backend.h"

/* Create the main interface */
void initialize_interface(StuffKeeperDataBackend *skdb, GtkListStore *tag_store, GtkListStore *items_store);


#endif
