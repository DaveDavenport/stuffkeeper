/* Include gtk */
#include <gtk/gtk.h>
#include <glade/glade.h>
/* Include the database */

#include "stuffkeeper-data-backend.h"
#include "stuffkeeper-data-schema.h"
#include "stuffkeeper-data-label.h"
#include "stuffkeeper-data-entry.h"
#include "stuffkeeper-data-boolean.h"
#include "stuffkeeper-data-spinbutton.h"
#include "stuffkeeper-data-taglist.h"

/* Include interface header file */
#include "interface.h"

GladeXML *xml = NULL;
StuffKeeperDataBackend *skdbg = NULL;


void tag_added(StuffKeeperDataBackend *skdb, StuffKeeperDataTag *tag, GtkListStore *store)
{
    GtkTreeIter iter;
    gtk_list_store_append(store, &iter);
    gchar *title = stuffkeeper_data_tag_get_title(tag);
    gtk_list_store_set(store, &iter, 0, stuffkeeper_data_tag_get_id(tag),1,title,3,tag, 4, stuffkeeper_data_tag_num_items(tag),-1);
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
                gtk_list_store_set(store, &iter, 1,title, 4, stuffkeeper_data_tag_num_items(tag),-1);
                g_free(title);
                return;
            }
        }while(gtk_tree_model_iter_next(model, &iter));
    }
}
void tag_removed(StuffKeeperDataBackend *skdb, gint id, GtkListStore *store)
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
                printf("Item items: %i\n", id);
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
    /** TODO, set schema */
    GList *list = stuffkeeper_data_backend_get_schemas(skdbg);
    if(list)
    {
        StuffKeeperDataItem *item = stuffkeeper_data_backend_new_item(skdbg,list->data);
        stuffkeeper_data_item_set_title(item,"New Item");
        g_list_free(list);
    }

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
                if(item && tag && stuffkeeper_data_item_has_tag(item, tag))
                    return 1;
            }

        }while(gtk_tree_model_iter_next(tagmodel, &piter));
    }

    return !has_selected;//retv;
}
void interface_entry_add(GtkWidget *button, gpointer data)
{

    GtkWidget *entry= glade_xml_get_widget(xml, "add_tag_entry");
    const gchar *title = gtk_entry_get_text(GTK_ENTRY(entry));
    StuffKeeperDataTag *tag;
    if(title == NULL || strlen(title) == 0)
        return;
    tag = stuffkeeper_data_backend_add_tag(skdbg,NULL,g_random_int());
    if(title && strlen(title) > 0)
        stuffkeeper_data_tag_set_title(tag, title);
}
/*
void interface_add_tag_to_item(GtkWidget *box, gpointer data)
{
    StuffKeeperDataTag *tag = g_object_get_data(G_OBJECT(box), "tag");
    StuffKeeperDataItem *item = g_object_get_data(G_OBJECT(box), "item");
    gboolean value = gtk_toggle_button_get_active(GTK_TOGGLE_BUTTON(box));
    if(value) {
        stuffkeeper_data_item_add_tag(item, tag);
    } else {
        stuffkeeper_data_item_remove_tag(item, tag);
    }

}
*/

void interface_item_selection_changed (GtkTreeSelection *selection, gpointer data)
{
    GtkTreeModel *model;
    GtkWidget *container,*tree,*event;
    GList *list;
    /** Remove all old widgets */
    container = glade_xml_get_widget(xml, "item_vbox");

    event =  glade_xml_get_widget(xml, "item_event_box");
    gtk_widget_modify_bg(event, GTK_STATE_NORMAL, &(container->style->white));

    list = gtk_container_get_children(GTK_CONTAINER(container));
    if(list)
    {
        GList *node;
        for(node = g_list_first(list); node; node = g_list_next(node))
        {
            gtk_widget_destroy(GTK_WIDGET(node->data));
        }
        g_list_free(list);
    }
    /**/
    tree = glade_xml_get_widget(xml, "treeview2");



    model = gtk_tree_view_get_model(GTK_TREE_VIEW(tree));
    GtkTreeIter iter;
    if(gtk_tree_selection_get_selected(selection, &model, &iter))
    {
        StuffKeeperDataItem *item;
        gtk_tree_model_get(model, &iter, 2, &item, -1);
        if(item)
        {
            /* The title */
            GtkWidget *vbox;
            GtkWidget *label1;

            vbox = gtk_hbox_new(FALSE, 6);
            /* Title */
            label1 = gtk_label_new("");
            gtk_label_set_markup(GTK_LABEL(label1), "<b>Title:</b>");
            gtk_misc_set_alignment(GTK_MISC(label1), 1,0.5);
            gtk_box_pack_start(GTK_BOX(vbox),label1, FALSE,TRUE, 0);

            label1 = stuffkeeper_data_entry_new(item,NULL);
            gtk_box_pack_start(GTK_BOX(vbox),label1, TRUE,TRUE, 0);

            /* type */
            StuffKeeperDataSchema *schema = stuffkeeper_data_item_get_schema(item);
            label1 =gtk_label_new("");
            gtk_label_set_markup(GTK_LABEL(label1), "<b>Type:</b>");
            gtk_box_pack_start(GTK_BOX(vbox),label1, FALSE,TRUE, 0);

            if(schema) {
                label1 = stuffkeeper_data_label_new_schema(schema);
            } else {
                label1 = gtk_label_new("N/A");
            }
            

            gtk_box_pack_start(GTK_BOX(vbox),label1, FALSE,TRUE, 0);
            gtk_box_pack_start(GTK_BOX(container),vbox, FALSE,TRUE, 0);
            label1 = gtk_label_new("");
            gtk_label_set_markup(GTK_LABEL(label1),"<span weight='bold' size='x-large'>Fields:</span>");
            gtk_misc_set_alignment(GTK_MISC(label1), 0,0.5);
            gtk_misc_set_padding(GTK_MISC(label1), 0,8);
            gtk_box_pack_start(GTK_BOX(container),label1, FALSE,TRUE, 0);

            /**
             * Get the attached schema and fill in the rest from there
             */
            if(schema)
            {
                gsize length;
                int i;
                gchar **retv = stuffkeeper_data_schema_get_fields(schema, &length);
                /* num fields + one for the tags */
                vbox = gtk_table_new(length+1, 2, FALSE);
                gtk_table_set_row_spacings(GTK_TABLE(vbox), 6);
                gtk_table_set_col_spacings(GTK_TABLE(vbox), 6);
                for(i=0;i<length;i++)
                {
                    FieldType type = stuffkeeper_data_schema_get_field_type(schema, retv[i]);
                    gchar *field_name = stuffkeeper_data_schema_get_field_name(schema, retv[i]);

                    /* Title */
                    label1 = gtk_label_new("");
                    gchar *val = g_markup_printf_escaped("<b>%s</b>", field_name);
                    gtk_label_set_markup(GTK_LABEL(label1), val);
                    g_free(val);
                    gtk_misc_set_alignment(GTK_MISC(label1), 1,0.5);
                    gtk_table_attach(GTK_TABLE(vbox), label1, 0,1,i,i+1,GTK_SHRINK|GTK_FILL, GTK_FILL, 0,0);
                    if(type == FIELD_TYPE_STRING)
                    {
                        label1 = stuffkeeper_data_entry_new(item,retv[i]);
                    }
                    else if (type == FIELD_TYPE_INTEGER)
                    {
                        label1 = stuffkeeper_data_spinbutton_new(item,retv[i]);
                    }else if (type == FIELD_TYPE_BOOLEAN) {
                        label1 = stuffkeeper_data_boolean_new(item,retv[i]);
                    }else {
                        label1 = gtk_label_new("not supported\n");
                    }
                    gtk_table_attach(GTK_TABLE(vbox), label1, 1,2,i,i+1,GTK_SHRINK|GTK_FILL, GTK_FILL, 0,0);
                    

                    g_free(field_name);
                }
                /**
                 * Fill in the Tag list 
                 */
                /* Title */
                label1 = gtk_label_new("");
                gchar *val = g_markup_printf_escaped("<b>%s</b>", "Tags");
                gtk_label_set_markup(GTK_LABEL(label1), val);
                g_free(val);
                gtk_misc_set_alignment(GTK_MISC(label1), 1,0.5);
                gtk_table_attach(GTK_TABLE(vbox), label1, 0,1,i,i+1,GTK_SHRINK|GTK_FILL, GTK_FILL, 0,0);

                label1 = stuffkeeper_data_taglist_new(skdbg,item);
                gtk_table_attach(GTK_TABLE(vbox), label1, 1,2,i,i+1,GTK_SHRINK|GTK_FILL, GTK_FILL, 0,0);

                gtk_box_pack_start(GTK_BOX(container),vbox, FALSE,TRUE, 0);
                g_strfreev(retv);
            }

                   }
    }
    gtk_widget_show_all(container);

}

void interface_remove_tag()
{
    GtkWidget *tree = glade_xml_get_widget(xml, "treeview1");
    GtkTreeModel *model = gtk_tree_view_get_model(GTK_TREE_VIEW(tree));
    GtkTreeSelection *sel = gtk_tree_view_get_selection(GTK_TREE_VIEW(tree));
    GtkTreeIter iter;
    if(gtk_tree_selection_get_selected(sel, &model, &iter))
    {
        StuffKeeperDataTag *tag;
        gtk_tree_model_get(model, &iter, 3, &tag, -1);
        if(tag)
        {
            if(stuffkeeper_data_tag_num_items(tag) > 0)
            {
                printf("This tag is not empty\n");
            }
            else
            {
                gint id = stuffkeeper_data_tag_get_id(tag); 
                printf("removing item: %i\n", id);
                stuffkeeper_data_backend_remove_tag(skdbg,id);
            }
        }
    }
}


/**
 * Initialize the main gui
 */
void initialize_interface(StuffKeeperDataBackend *skdb)
{
    GtkTreeViewColumn *column;
    GtkCellRenderer *renderer;
    GtkWidget *tree;
    GtkTreeModel *store,*filter;
    GtkTreeSelection *sel;

    GtkListStore *original;
    /* This is a hack for testing now */
    skdbg = skdb;

    xml = glade_xml_new ("stuffkeeper.glade", "win", NULL);
    original = gtk_list_store_new(3, G_TYPE_INT,G_TYPE_STRING,G_TYPE_POINTER);

    tree = glade_xml_get_widget(xml, "treeview2");

    renderer = gtk_cell_renderer_text_new();
    gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(tree), -1, "test", renderer, "text", 1, NULL);
    g_object_set(renderer, "editable", TRUE,NULL);


    g_signal_connect(G_OBJECT(skdb), "item-added", G_CALLBACK(item_added), original);
    g_signal_connect(G_OBJECT(skdb), "item-removed", G_CALLBACK(item_removed), original);
    g_signal_connect(G_OBJECT(skdb), "item-changed", G_CALLBACK(item_changed), original);

    filter = (GtkTreeModel *)gtk_tree_model_filter_new(GTK_TREE_MODEL(original), NULL);
    g_signal_connect(G_OBJECT(renderer), "edited", G_CALLBACK(interface_edited), filter);
    gtk_tree_view_set_model(GTK_TREE_VIEW(tree), GTK_TREE_MODEL(filter));

    sel = gtk_tree_view_get_selection(GTK_TREE_VIEW(tree));
    g_signal_connect(G_OBJECT(sel), "changed", G_CALLBACK(interface_item_selection_changed), NULL);

    /* Tag list */



    store = (GtkTreeModel *)gtk_list_store_new(5, G_TYPE_INT,G_TYPE_STRING,G_TYPE_BOOLEAN,G_TYPE_POINTER,G_TYPE_INT);
    gtk_tree_model_filter_set_visible_func(GTK_TREE_MODEL_FILTER(filter), (GtkTreeModelFilterVisibleFunc)interface_visible_func, store, NULL);

    tree = glade_xml_get_widget(xml, "treeview1");

    column = gtk_tree_view_column_new();

    /* Toggle button  */
    renderer = gtk_cell_renderer_toggle_new();
    gtk_tree_view_column_pack_start(GTK_TREE_VIEW_COLUMN(column), renderer, FALSE);
    g_object_set_data(G_OBJECT(renderer),"model1", filter); 
    gtk_tree_view_column_set_attributes(column, renderer, "active", 2, NULL);
    g_signal_connect(G_OBJECT(renderer), "toggled", G_CALLBACK(interface_tag_toggled), store);

    /* Tag name */
    renderer = gtk_cell_renderer_text_new();
    gtk_tree_view_column_pack_start(GTK_TREE_VIEW_COLUMN(column), renderer, TRUE);
    gtk_tree_view_column_set_attributes(column, renderer, "text", 1, NULL);
    g_object_set(renderer, "editable", TRUE,NULL);
    g_signal_connect(G_OBJECT(renderer), "edited", G_CALLBACK(interface_tag_edited), store);

    /* Number of items */
    renderer = gtk_cell_renderer_text_new();
    g_object_set(G_OBJECT(renderer), "background-set", TRUE, "background", "black", "foreground-set", TRUE, "foreground", "white",NULL);
    gtk_tree_view_column_pack_start(GTK_TREE_VIEW_COLUMN(column), renderer, FALSE);
    gtk_tree_view_column_set_attributes(column, renderer, "text", 4, NULL);

    gtk_tree_view_append_column(GTK_TREE_VIEW(tree), column);

    g_signal_connect(G_OBJECT(skdb), "tag-added", G_CALLBACK(tag_added), store);
    g_signal_connect(G_OBJECT(skdb), "tag-changed", G_CALLBACK(tag_changed), store);
    g_signal_connect(G_OBJECT(skdb), "tag-removed", G_CALLBACK(tag_removed), store);


    gtk_tree_view_set_model(GTK_TREE_VIEW(tree), GTK_TREE_MODEL(store));




    glade_xml_signal_autoconnect(xml);
}
