/* This needs editing ! */ 

[CCode (cprefix = "Stuffkeeper", lower_case_cprefix = "stuffkeeper_")]
namespace Stuffkeeper {
	[CCode (cprefix = "DB_ITEMS_FIELD_TYPE_", has_type_id = "0", cheader_filename = "stuffkeeper-plugin.h")]
	public enum DbItemFieldType {
		ID,
		TYPE,
		NAME
	}
	[CCode (cprefix = "DB_ITEMS_TYPE_", has_type_id = "0", cheader_filename = "stuffkeeper-plugin.h")]
	public enum DbItemType {
		ID,
		SCHEMA,
		MTIME,
		CTIME,
		TAG,
		NAME,
		NAME_GENERATED_CACHE
	}
	[CCode (cprefix = "DB_SCHEMAS_FIELD_TYPE_", has_type_id = "0", cheader_filename = "stuffkeeper-plugin.h")]
	public enum DbSchemaFieldType {
		ID,
		ORDER,
		TYPE,
		NAME,
		IN_TITLE
	}
	[CCode (cprefix = "DB_SCHEMAS_TYPE_", has_type_id = "0", cheader_filename = "stuffkeeper-plugin.h")]
	public enum DbSchemaType {
		ID,
		MTIME,
		CTIME,
		ICON,
		NAME
	}
	[CCode (cname="FieldType", cprefix = "FIELD_TYPE_", has_type_id = "0", cheader_filename = "stuffkeeper-plugin.h")]
	public enum FieldType {
        STRING = 0,
        INTEGER = 1,
        BOOLEAN = 2,
        RATING = 3,
        LIST = 4,
        TEXT = 5,
        IMAGE = 6,
        LINK = 7,
        DATE = 8,
        EXPANDER = 9,
        END_EXPANDER = 10,
        VPACKING = 11,
        END= 12,
        HPACKING = 13,
        PASSWORD = 14,
        FILES = 15,
        NUM_FIELDS
	}
	[CCode (cprefix = "PLUGIN_", has_type_id = "0", cheader_filename = "stuffkeeper-plugin.h")]
	public enum PluginType {
		NONE,
		ITEM,
		BACKGROUND,
		MENU
	}
	[CCode (cprefix = "", has_type_id = "0", cheader_filename = "stuffkeeper-plugin.h")]
	public enum SearchFieldType {
		SEARCH_TITLE,
		SEARCH_FIELD_SCHEMA,
		SEARCH_FIELD_TAG,
		SEARCH_FIELD_TITLE,
		SEARCH_FIELD_VALUE,
		NUM_SEARCH_FIELD
	}
	[CCode (cprefix = "SEARCH_TYPE_", has_type_id = "0", cheader_filename = "stuffkeeper-plugin.h")]
	public enum SearchType {
		NONE,
		IS,
		IS_NOT,
		CONTAINS,
		NOT_CONTAINS,
		NUM_ITEMS
	}
	[Compact]
	[CCode (cheader_filename = "stuffkeeper-plugin.h")]
	public class SearchField {
		public int id;
		public int field_id;
		public Stuffkeeper.SearchFieldType field_type;
		public Stuffkeeper.SearchType type;
		public unowned string value;
	}
	[Compact]
	[CCode (cheader_filename = "stuffkeeper-plugin.h")]
	public class DataBackend : GLib.Object {
		public unowned Stuffkeeper.DataTag add_tag (int id);
		public void begin_transaction ();
		public void close_yourself ();
		public void end_transaction ();
		public void* get_handle ();
		public unowned Stuffkeeper.DataItem get_item (int id);
		public unowned GLib.List get_items ();
		public bool get_locked ();
		public uint get_num_items ();
		public uint get_num_searches ();
		public unowned string get_path ();
		public unowned Stuffkeeper.DataSchema get_schema (int id);
		public GLib.List<unowned DataSchema> get_schemas ();
		public unowned Stuffkeeper.DataItemSearch get_search (int id);
		public unowned GLib.List get_searches ();
		public unowned Stuffkeeper.DataTag get_tag (int id);
		public GLib.List<unowned DataTag> get_tags ();
		public void load (string db_path);
		public unowned Stuffkeeper.DataSchema load_from_xml (string path);
		public DataBackend ();
		public unowned DataItem new_item (Stuffkeeper.DataSchema schema);
		public DataBackend.schema (Stuffkeeper.DataBackend self);
		public DataBackend.search (Stuffkeeper.DataBackend self);
		public DataBackend.tag (Stuffkeeper.DataBackend self);
		public void remove_item (int id);
		public void remove_schema (int id);
		public void remove_search (int id);
		public void remove_tag (int id);
		public void set_locked (bool val);
		[HasEmitter]
		public virtual signal void tag_added(Stuffkeeper.DataTag tag);
		public virtual signal void tag_changed(Stuffkeeper.DataTag tag);
		public virtual signal void tag_removed(uint id);
	}
	[Compact]
	[CCode (cheader_filename = "stuffkeeper-plugin.h")]
	public class DataBackendClass {
		public unowned GLib.Callback search_changed;
		public unowned GLib.Callback search_added;
		public unowned GLib.Callback search_removed;
		public unowned GLib.Callback item_changed;
		public unowned GLib.Callback item_added;
		public unowned GLib.Callback item_removed;
		public unowned GLib.Callback schema_changed;
		public unowned GLib.Callback schema_added;
		public unowned GLib.Callback schema_removed;
		public unowned GLib.Callback tag_changed;
	}
	[Compact]
	[CCode (cheader_filename = "stuffkeeper-plugin.h")]
	public class DataItem : GLib.Object{
		public void add_tag (Stuffkeeper.DataTag tag);
		public void delete_yourself ();
		public unowned Stuffkeeper.DataBackend get_backend ();
		public int get_boolean (string field);
		public int get_creation_time ();
		public int get_id ();
		public int get_integer (string field);
		public bool get_integer_real (string field, int @out);
		public unowned string[] get_list (string field);
		public int get_modification_time ();
		public unowned Stuffkeeper.DataSchema get_schema ();
		public unowned string get_string (string field);
		public unowned GLib.List get_tags ();
		public string get_title ();
		public int has_generated_title ();
		public bool has_tag (Stuffkeeper.DataTag tag);
		public bool has_value (string value);
		public bool has_value_exact (string value);
		public DataItem (GLib.Object skdb, Stuffkeeper.DataSchema schema);
		public static unowned Stuffkeeper.DataItem open_from_id (GLib.Object skdb, int id, int schemaid);
		public void remove_tag (Stuffkeeper.DataTag tag);
		public void save_yourself ();
		public void set_boolean (string field, bool value);
		public void set_integer (string id, int title);
		public void set_list (string field, string[] value);
		public void append_list (string field, string[] value);
		public void remove_from_list (string field, string value);
		public void set_string (string id, string title);
		public void set_title (string title);

        
		[HasEmitter]
		public virtual signal void item_tags_changed ();
        public virtual signal void item_changed (string field);

	}
	[Compact]
	[CCode (cheader_filename = "stuffkeeper-plugin.h")]
	public class DataItemClass {
		public unowned GLib.Callback item_changed;
		public unowned GLib.Callback item_tags_changed;
	}
	[Compact]
	[CCode (cheader_filename = "stuffkeeper-plugin.h")]
	public class DataItemSearch {
		public void add_field (Gtk.Widget button);
		public void delete_yourself ();
		public void edit_search_field (Stuffkeeper.SearchField field);
		public void edit_search_gui ();
		public static void free_search_field (Stuffkeeper.SearchField field);
		public int get_id ();
		public unowned GLib.List get_search_fields ();
		public unowned string get_title ();
		public int match (Stuffkeeper.DataItem item);
		public DataItemSearch (GLib.Object skdb);
		public DataItemSearch.dummy ();
		public DataItemSearch.search_field (Stuffkeeper.DataItemSearch self, Stuffkeeper.SearchType searchtype, Stuffkeeper.SearchFieldType fieldtype, string value);
		public static unowned GLib.Object open_from_id (GLib.Object skdb, int id);
		public void remove_field (Gtk.Widget button);
		public void remove_search_field (Stuffkeeper.SearchField field);
		public void search_changed (Stuffkeeper.SearchField field);
		public void search_title_changed (Gtk.Widget entry);
		public void set_string (int searchtype, int fieldtype, string title);
		public void set_title (string title);
		public void style_set (Gtk.Style style, Gtk.Widget wid);
	}
	[Compact]
	[CCode (cheader_filename = "stuffkeeper-plugin.h")]
	public class DataItemSearchClass {
		public unowned GLib.Callback search_changed;
	}
	[Compact]
	[CCode (cheader_filename = "stuffkeeper-plugin.h")]
	public class DataSchema : GLib.Object{
		public void add_field (Stuffkeeper.FieldType field, string name, int in_title);
		public void add_item (GLib.Object item);
		public void delete_yourself ();
		public void field_reorder (out unowned string fields);
		public void field_schemas_set_field_string (int fieldtype, string id, string title);
		public unowned GLib.Object get_backend ();
		public int get_field_in_title (string id);
		public unowned string get_field_name (string id);
		public unowned string get_field_id_by_name(string name);
		public int get_field_pos (string id);
		public Stuffkeeper.FieldType get_field_type (string id);
		public string[] get_fields ();
		public int get_id ();
		public unowned GLib.List get_items ();
		public unowned Gdk.Pixbuf get_pixbuf ();
		public unowned string get_title ();
		public int has_generated_title ();
		public static unowned Stuffkeeper.DataSchema load_from_xml (GLib.Object skdb, string path);
		public DataSchema (GLib.Object skdb);
		public DataSchema.with_id (GLib.Object skdb, int id);
		public int num_items ();
		public static unowned Stuffkeeper.DataSchema open_from_id (GLib.Object skdb, int id);
		public void remove_field (string id);
		public void remove_item (GLib.Object item);
		public bool save_to_xml (string path);
		public void save_yourself ();
		public void schemas_set_field (int fieldtype, string title);
		public void set_field_in_title (string id, int in_title);
		public void set_field_name (string id, string name);
		public void set_field_type (string id, Stuffkeeper.FieldType type);
		public void set_icon (string filename);
		public void set_title (string title);

		public string get_custom_field_string (string id, int field);
		public bool get_custom_field_integer (string id, int field, out int value);

		public void set_custom_field_integer (string id, int field, int value);


		[HasEmitter]
		public virtual signal void schema_custom_field_changed(string id, int field);




	}
	[Compact]
	[CCode (cheader_filename = "stuffkeeper-plugin.h")]
	public class DataSchemaClass {
		public unowned GLib.Callback schema_changed;
		public unowned GLib.Callback schema_field_changed;
		public unowned GLib.Callback schema_field_added;
		public unowned GLib.Callback schema_fields_reordered;
		public unowned GLib.Callback schema_field_removed;
	}
	[Compact]
	[CCode (cheader_filename = "stuffkeeper-plugin.h")]
	public class DataTag : GLib.Object {
		public void add_item (GLib.Object item);
		public void delete_yourself ();
		public int get_id ();
		public unowned string get_title ();
		public DataTag (GLib.Object skdb);
		public DataTag.with_id (GLib.Object skdb, int id);
		public int num_items ();
		public static unowned Stuffkeeper.DataTag open_from_id (GLib.Object skdb, int id);
		public void remove_item (GLib.Object item);
		public void set_title (string title);
	}
	[Compact]
	[CCode (cheader_filename = "stuffkeeper-plugin.h")]
	public class DataTagClass {
		public unowned GLib.Callback tag_changed;
	}
	[Compact]
	[CCode (cheader_filename = "stuffkeeper-plugin.h")]
	public class Interface {
		public void about_dialog ();
		public void backend_locked_toggled (Gtk.ToggleButton button);
		public bool close_window ();
		public void edit_search ();
		public void edit_search_menu (Gtk.Widget menu_item);
		public static void entry_changed (Gtk.Widget entry, Gtk.Widget button);
		public void export_html_item ();
		public void export_to_html ();
		public void filename_changed (Gtk.Widget entry);
		public void first_run ();
		public static void get_pixbuf (Gtk.TreeViewColumn column, Gtk.CellRenderer renderer, Gtk.TreeModel model, Gtk.TreeIter iter, void* data);
		public void initialize_interface (Stuffkeeper.DataBackend skdb, GLib.Object spm);
		public void interface_item_add (Gtk.Widget button);
		public void interface_item_add_menu (Gtk.Widget but);
		public void interface_item_open ();
		public void interface_item_remove ();
		public static bool interface_visible_func (Gtk.TreeModel model, Gtk.TreeIter iter, Stuffkeeper.Interface self);
		public bool item_is_visible (Stuffkeeper.DataItem item);
		public void item_pane_checkbox (Gtk.CheckMenuItem item);
		public void item_row_activated (Gtk.TreePath path, Gtk.TreeViewColumn column, Gtk.TreeView view);
		public void left_pane_changed (Gtk.ComboBox box);
		public void make_backup ();
		public void menu_backend_locked_toggled (Gtk.CheckMenuItem item);
		public Interface (GLib.KeyFile config_file);
		public Interface.search (Stuffkeeper.Interface self);
		public Interface.window (Stuffkeeper.Interface self);
		public void popup_item (Stuffkeeper.DataItem item);
		public void present ();
		public static void quit_program ();
		public void reload ();
		public void remove_search ();
		public void remove_search_menu (Gtk.Widget menu_item);
		public void restore_backup ();
		public void schema_export ();
		public void schema_import ();
		public void schema_new ();
		public void search_entry_changed ();
		public void search_type_changed (Gtk.ComboBox box);
		public void sort_item_ascending (Gtk.RadioButton style);
		public void sort_item_by_creation_time (Gtk.RadioButton style);
		public void sort_item_by_modification_time (Gtk.RadioButton style);
		public void sort_item_by_schema (Gtk.RadioButton style);
		public void sort_item_by_title (Gtk.RadioButton style);
		public void sort_item_descending (Gtk.RadioButton style);
		public static void style_changed (Gtk.Widget tree, Gtk.Style old, Gtk.CellRenderer renderer);
		public bool treeview1_button_press_event (Gdk.EventButton event, Gtk.Widget widget);
		public bool treeview1_button_release_event (Gdk.EventButton event, Gtk.Widget widget);
		public bool treeview2_button_press_event (Gdk.EventButton event, Gtk.Widget widget);
		public bool treeview2_button_release_event (Gdk.EventButton event, Gtk.Widget widget);
		public void visit_bugtracker ();
		public void visit_homepage ();
	}
	[Compact]
	[CCode (cheader_filename = "stuffkeeper-plugin.h")]
	public class InterfaceClass {
	}
	[Compact]
	[CCode (cheader_filename = "stuffkeeper-plugin.h")]
	public class Plugin : GLib.Object {
		public Plugin();
		public virtual Gdk.Pixbuf? get_icon ();
		public virtual unowned string get_name ();
		public virtual Stuffkeeper.PluginType get_plugin_type ();
		public virtual void run_background (Stuffkeeper.DataBackend skdb);
		public virtual void run_item (Stuffkeeper.DataItem item);
		public virtual void run_menu (Stuffkeeper.DataBackend skdb);
	}
	[Compact]
	[CCode (cheader_filename = "stuffkeeper-plugin.h")]
	public class PluginClass {
		public unowned GLib.Callback get_plugin_type;
		public unowned GLib.Callback get_name;
		public unowned GLib.Callback run_item;
		public unowned GLib.Callback run_menu;
		public unowned GLib.Callback run_background;
		public unowned GLib.Callback get_icon;
	}
	[CCode (cname = "register_plugin", cheader_filename = "stuffkeeper-plugin.h")]
	public static GLib.Type register_plugin ();

    [CCode (cheader_filename="stuffkeeper-data-entry.h")]
    public class DataEntry : Gtk.Entry 
    {
        public DataEntry(DataItem item, string? field);

    }

    [CCode (cheader_filename="stuffkeeper-data-label.h")]
    public class DataLabel : Gtk.Label 
    {
        public DataLabel.tag (DataTag tag);
        public DataLabel.schema(DataSchema schema);
        public DataLabel.schema_field(DataSchema schema,string field);


    }
    [CCode (cheader_filename="stuffkeeper-item-window.h")]
	    public class ItemWindow: Gtk.Window 
    {
	public ItemWindow (Stuffkeeper.DataBackend skdb, Stuffkeeper.DataItem item, GLib.KeyFile config_file);
    }
	[CCode (cname="config_file")]
    public GLib.KeyFile config_file;
	[CCode (cname="interface_element_add")]
	public void interface_element_add(Gtk.Window *win);
}
