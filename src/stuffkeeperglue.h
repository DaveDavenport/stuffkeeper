#ifndef __TYPEDEF_STUFFKEEPER_DATA_BACKEND__
#define __TYPEDEF_STUFFKEEPER_DATA_BACKEND__
typedef struct _StuffkeeperDataBackend StuffkeeperDataBackend;
#endif

#ifndef __TYPEDEF_STUFFKEEPER_DATA_ITEM__
#define __TYPEDEF_STUFFKEEPER_DATA_ITEM__
typedef struct _StuffkeeperDataItem StuffkeeperDataItem;
#endif

#ifndef __TYPEDEF_STUFFKEEPER_INTERFACE__
#define __TYPEDEF_STUFFKEEPER_INTERFACE__
typedef struct _StuffkeeperInterface StuffkeeperInterface;
#endif

#ifndef __STUFFKEEPERGLUE_H__
#define __STUFFKEEPERGLUE_H__
#include <gtk/gtk.h>
void interface_element_add(GtkWidget *win);
void interface_element_destroyed(GtkWidget *win, gpointer data);
#endif
