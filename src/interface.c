/* Include gtk */
#include <gtk/gtk.h>
#include <glade/glade.h>
/* Include the database */
#include "stuffkeeper-data-backend.h"
/* Include interface header file */
#include "interface.h"

GladeXML *xml = NULL;
StuffKeeperDataBackend *skdbg = NULL;


void tag_added(StuffKeeperDataBackend *skdb, StuffKeeperDataTag *tag, GtkListStore *store)
{
    GtkTreeIter iter;
    gtk_list_store_append(store, &iter);
    gchar *title = stuffkeeper_data_tag_get_title(tag);
    gtk_list_store_set(store, &iter, 0, stuffkeeper_data_tag_get_id(tag),1,title,3,tag, -1);
    g_free(title);
}

void tag_changed(StuffKeeperDataBackend *skdb, StuffKeeperDataTag *tag, GtkListStore *store)
{
    GtkTreeIter iter;
    GtkTreeModel *model = GTK_TREE_MODEL(store);
    gint id = stuffkeeper_data_tag_get_id(tag);
    if(gtk_tree_model_get_iter_first(model, &iter))
    {
        do{
            gint oid;
            gtk_tree_model_get(model, &iter, 0, &oid, -1);
            if(oid == id)
            {
                gchar *title = stuffkeeper_data_tag_get_title(tag);
                gtk_list_store_set(store, &iter, 1,title, -1);
                g_free(title);
                return;
            }
        }while(gtk_tree_model_iter_next(model, &iter));
    }
}

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
    gchar *title = stuffkeeper_data_item_get_title(item);
    gtk_list_store_set(store, &iter, 0, stuffkeeper_data_item_get_id(item),1,title, 2,item,-1);
    g_free(title);


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
                gchar *title = stuffkeeper_data_item_get_title(item);
                gtk_list_store_set(store, &iter, 1,title, -1);
                g_free(title);
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
    GtkWidget *tree = glade_xml_get_widget(xml, "treeview2");
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
void interface_tag_toggled(GtkCellRendererToggle *renderer, gchar *path, GtkTreeModel *model)
{
    GtkTreeIter iter;
    if(gtk_tree_model_get_iter_from_string(model, &iter, path))
    {
        gboolean value = !gtk_cell_renderer_toggle_get_active(renderer);
        gtk_list_store_set(GTK_LIST_STORE(model), &iter, 2,value,-1);
        GtkTreeModel *model1 = g_object_get_data(G_OBJECT(renderer), "model1");
        gtk_tree_model_filter_refilter(GTK_TREE_MODEL_FILTER(model1));

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
void interface_tag_edited 
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
        StuffKeeperDataTag *item;
        gtk_tree_model_get(model, &iter ,0,&id, -1);
        printf("get tag: %i\n",id);
        item = stuffkeeper_data_backend_get_tag(skdbg, id);
        if(item)
        {
            stuffkeeper_data_tag_set_title(item, new_text);
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

gboolean interface_visible_func(GtkTreeModel *model, GtkTreeIter *iter, GtkTreeModel *tagmodel)
{
    gchar *test;
    int retv =     1;
    int has_selected = 0;
    StuffKeeperDataItem *item;
    gtk_tree_model_get(model, iter, 1, &test,2,&item, -1);

    GtkTreeIter piter;
    if(gtk_tree_model_get_iter_first(tagmodel, &piter))
    {
        do{
            StuffKeeperDataTag *tag;
            gboolean sel;
            gtk_tree_model_get(tagmodel, &piter,2,&sel, 3,&tag, -1);
            if(sel)
            {
                has_selected = 1;
                if(stuffkeeper_data_item_has_tag(item, tag))
                    return 1;
            }

        }while(gtk_tree_model_iter_next(tagmodel, &piter));
    }

    return !has_selected;//retv;
}
/**
 * Initialize the main gui
 */
void initialize_interface(StuffKeeperDataBackend *skdb)
{
    GtkCellRenderer *renderer;
    GtkTreeViewColumn *column;
    GtkWidget *tree;
    GtkListStore *store2;
    GtkTreeModel *store,*filter;

    GtkListStore *original;
    /* This is a hack for testing now */
    skdbg = skdb;

	xml = glade_xml_new ("stuffkeeper.glade", "win", NULL);
    original = gtk_list_store_new(3, G_TYPE_INT,G_TYPE_STRING,G_TYPE_POINTER);

    tree = glade_xml_get_widget(xml, "treeview2");
   
    renderer = gtk_cell_renderer_text_new();
    gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(tree), -1, "test", renderer, "text", 1, NULL);
    g_object_set(renderer, "editable", TRUE,NULL);
    g_signal_connect(G_OBJECT(renderer), "edited", G_CALLBACK(interface_edited), original);

    g_signal_connect(G_OBJECT(skdb), "item-added", G_CALLBACK(item_added), original);
    g_signal_connect(G_OBJECT(skdb), "item-removed", G_CALLBACK(item_removed), original);
    g_signal_connect(G_OBJECT(skdb), "item-changed", G_CALLBACK(item_changed), original);

    filter = (GtkTreeModel *)gtk_tree_model_filter_new(GTK_TREE_MODEL(original), NULL);

    gtk_tree_view_set_model(GTK_TREE_VIEW(tree), GTK_TREE_MODEL(filter));

    /* Tag list */


    store = (GtkTreeModel *)gtk_list_store_new(4, G_TYPE_INT,G_TYPE_STRING,G_TYPE_BOOLEAN,G_TYPE_POINTER);
    gtk_tree_model_filter_set_visible_func(GTK_TREE_MODEL_FILTER(filter), interface_visible_func, store, NULL);

    tree = glade_xml_get_widget(xml, "treeview1");
    renderer = gtk_cell_renderer_toggle_new();
    g_object_set_data(G_OBJECT(renderer),"model1", filter); 

    gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(tree), -1, "test", renderer, "active", 2, NULL);
    g_signal_connect(G_OBJECT(renderer), "toggled", G_CALLBACK(interface_tag_toggled), store);
    renderer = gtk_cell_renderer_text_new();
    gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(tree), -1, "test", renderer, "text", 1, NULL);
    g_object_set(renderer, "editable", TRUE,NULL);
    g_signal_connect(G_OBJECT(renderer), "edited", G_CALLBACK(interface_tag_edited), store);



    g_signal_connect(G_OBJECT(skdb), "tag-added", G_CALLBACK(tag_added), store);

    g_signal_connect(G_OBJECT(skdb), "tag-changed", G_CALLBACK(tag_changed), store);
    gtk_tree_view_set_model(GTK_TREE_VIEW(tree), GTK_TREE_MODEL(store));




    glade_xml_signal_autoconnect(xml);
}
