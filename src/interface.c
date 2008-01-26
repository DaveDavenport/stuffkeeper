/* Include gtk */
#include <gtk/gtk.h>
#include <glade/glade.h>
/* Include the database */
#include "stuffkeeper-data-backend.h"
/* Include interface header file */
#include "interface.h"

GladeXML *xml = NULL;
StuffKeeperDataBackend *skdbg = NULL;
/**
 * Update the gtk-list-store with signals from the backend
 */
void item_removed(StuffKeeperDataBackend *skdb, gint id, GtkListStore *store)
{
    GtkTreeIter iter;
    GtkTreeModel *model = GTK_TREE_MODEL(store);
    if(gtk_tree_model_get_iter_first(model, &iter))
    {
        do{
            gint oid;
            gtk_tree_model_get(model, &iter, 0, &oid, -1);
            if(oid == id)
            {
                gtk_list_store_remove(store, &iter);
                return;
            }
        }while(gtk_tree_model_iter_next(model, &iter));
    }
}
void item_added(StuffKeeperDataBackend *skdb, StuffKeeperDataItem *item, GtkListStore *store)
{
    GtkTreeIter iter;
    gtk_list_store_append(store, &iter);
    gtk_list_store_set(store, &iter, 0, stuffkeeper_data_item_get_id(item),1,stuffkeeper_data_item_get_title(item), -1);


}
void item_changed(StuffKeeperDataBackend *skdb, StuffKeeperDataItem *item, GtkListStore *store)
{
    GtkTreeIter iter;
    GtkTreeModel *model = GTK_TREE_MODEL(store);
    gint id = stuffkeeper_data_item_get_id(item);
    if(gtk_tree_model_get_iter_first(model, &iter))
    {
        do{
            gint oid;
            gtk_tree_model_get(model, &iter, 0, &oid, -1);
            if(oid == id)
            {
                gtk_list_store_set(store, &iter, 1,stuffkeeper_data_item_get_title(item), -1);
                return;
            }
        }while(gtk_tree_model_iter_next(model, &iter));
    }
}

/**
 * Add item button clicked 
 */
void interface_item_add(void)
{
    stuffkeeper_data_backend_new_item(skdbg);
}
/**
 * Remove selected item
 */
void interface_item_remove(void)
{
    GtkWidget *tree = glade_xml_get_widget(xml, "treeview1");
    GtkTreeSelection *selection = gtk_tree_view_get_selection(GTK_TREE_VIEW(tree));
    GtkTreeModel *model = GTK_TREE_MODEL(gtk_tree_view_get_model(GTK_TREE_VIEW(tree)));
    GtkTreeIter iter;
    if(gtk_tree_selection_get_selected(selection, &model, &iter))
    {
        gint id;
        gtk_tree_model_get(model, &iter ,0,&id, -1);
        printf("requesting removal of: %i\n", id);
        stuffkeeper_data_backend_remove_item(skdbg, id);

    }
}
    
void interface_edited 
    (
        GtkCellRendererText *renderer,
        gchar               *path,
        gchar               *new_text,
        GtkTreeModel        *model)
{
    GtkTreeIter iter;
    printf("edited: %s\n", new_text);
    if(gtk_tree_model_get_iter_from_string(model, &iter, path))
    {
        gint id;
        StuffKeeperDataItem *item;
        gtk_tree_model_get(model, &iter ,0,&id, -1);
        printf("get item: %i\n",id);
        item = stuffkeeper_data_backend_get_item(skdbg, id);
        if(item)
        {
            stuffkeeper_data_item_set_title(item, new_text);
        }

    }
}
/**
 * Quit the program
 */
void quit_program(void)
{
    gtk_main_quit();
}

gboolean interface_visible_func(GtkTreeModel *model, GtkTreeIter *iter, gpointer data)
{
    gchar *test;
    int retv =     1;
    gtk_tree_model_get(model, iter, 1, &test, -1);
    if(test && strcmp(test, "test") == 0)
        retv = 0;

    return retv;
}
/**
 * Initialize the main gui
 */
void initialize_interface(const StuffKeeperDataBackend *skdb)
{
    GtkCellRenderer *renderer;
    GtkTreeViewColumn *column;
    GtkWidget *tree;
    GtkListStore *store2,*store;

    GtkListStore *original;
    /* This is a hack for testing now */
    skdbg = skdb;

	xml = glade_xml_new ("stuffkeeper.glade", "win", NULL);
    original = gtk_list_store_new(2, G_TYPE_INT,G_TYPE_STRING);

    tree = glade_xml_get_widget(xml, "treeview2");
   
    renderer = gtk_cell_renderer_text_new();
    gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(tree), -1, "test", renderer, "text", 1, NULL);
    g_object_set(renderer, "editable", TRUE);
    g_signal_connect(G_OBJECT(renderer), "edited", G_CALLBACK(interface_edited), original);

    g_signal_connect(G_OBJECT(skdb), "item-added", G_CALLBACK(item_added), original);
    g_signal_connect(G_OBJECT(skdb), "item-removed", G_CALLBACK(item_removed), original);
    g_signal_connect(G_OBJECT(skdb), "item-changed", G_CALLBACK(item_changed), original);

    store = gtk_tree_model_filter_new(GTK_TREE_MODEL(original), NULL);
    gtk_tree_model_filter_set_visible_func(GTK_TREE_MODEL_FILTER(store), interface_visible_func, NULL, NULL);
    gtk_tree_view_set_model(GTK_TREE_VIEW(tree), GTK_TREE_MODEL(store));
    /* testing */
    store2 = gtk_list_store_new(2, G_TYPE_INT,G_TYPE_STRING);
    tree = glade_xml_get_widget(xml, "treeview1");
    gtk_tree_view_set_model(GTK_TREE_VIEW(tree), GTK_TREE_MODEL(store2));
    renderer = gtk_cell_renderer_text_new();
    gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(tree), -1, "test", renderer, "text", 1, NULL);
    g_object_set(renderer, "editable", TRUE);
    g_signal_connect(G_OBJECT(renderer), "edited", G_CALLBACK(interface_edited), store2);

    g_signal_connect(G_OBJECT(skdb), "item-added", G_CALLBACK(item_added), store2);
    g_signal_connect(G_OBJECT(skdb), "item-removed", G_CALLBACK(item_removed), store2);
    g_signal_connect(G_OBJECT(skdb), "item-changed", G_CALLBACK(item_changed), store2);


    glade_xml_signal_autoconnect(xml);
}
