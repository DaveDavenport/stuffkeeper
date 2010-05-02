/*
TODO:
* Somehow not all ref's to DataBackend are not released.
* Remember (or auto) match field with entry.

*/
using GLib;
using Gtk;
using Stuffkeeper;

errordomain ItemParserDataError {
    NO_UTF8,
    INVALID_STRUCTURE,
    DUPLICATE_ENTRIES
}
/**
 * Data format:
 * * Contains data for 1 item. 
 * * There is one entry per line (matching a entry in the type)
 * * The line is  <field>::<data> 
 *   * <field> is simple alfanumeric. 
 *   * <field> is unique,
 *   * <data> is simple string where newline is escaped. \n
 *   * All input data is valid utf-8!
 *   * Boolean data are (for true):  YES, yes, 1, true, TRUE
 */
private class ItemParser {
    /* The key pair combination */
    private GLib.HashTable<string, string> values = new HashTable<string, string>.full(str_hash, str_equal, g_free, g_free);


    /* The separator used */
    private const string Separator = "::";


    /* Take the input string and parse it. */
    public ItemParser(string data) throws ItemParserDataError
    {
        /* Validate if the input data is utf8 */
        if(!data.validate())
        {
            /* Make this an GError, with trowing errors and so */
            throw new ItemParserDataError.NO_UTF8("Input data is not valid utf8");              
        }


        /* Split data into lines */
        string[] lines = data.split("\n",-1);


        /* Parse each line */
        foreach(string line in lines)
        {
            /* Skip empty lines */
            if(line.length == 0) continue;
            /* Split the line on the separator */
            string[] entries = line.split(Separator, 2);
            /* If the line does not consist of 2 entries, we bail out and throw an error. */
            if(entries.length != 2) {
                GLib.warning("The splitted line: '%s' has only one entry", line);
                throw new ItemParserDataError.INVALID_STRUCTURE("Input data has invalid structure");              
            }
            GLib.debug("parsed line: %s -> %s '%s'", line, entries[0], entries[1]);
            /* Insert into hash key */
            if(!values.lookup_extended(entries[0], null, null)){
                values.insert(entries[0], entries[1]);
            }else{
                throw new ItemParserDataError.DUPLICATE_ENTRIES("Input data contained duplicate entries");        
            }
        }
    }

    public List<unowned string> get_fields()
    {
        return values.get_keys();
    }

    public string? get_value(string field)
    {
        string value = values.lookup(field);
        if(value == null) return null;
        return value.compress();
    }
}

/**
 * This dialog will have 3 pages:
 * 1. Type of data to add (CD/Book etc)
 * 2. Input (script/file)
 * 3. Import (where the user selects what data to be added in what field)
 */
private class GenericInputDialog:GLib.Object
{
    private Gtk.Assistant ass = new Gtk.Assistant();
	private DataBackend skdb  = null;
    private DataSchema schema = null;
    private ListStore schemas = new Gtk.ListStore(3,typeof(DataSchema),typeof(string), typeof(Gdk.Pixbuf)); 
    private ItemParser p = null;

    public GenericInputDialog(DataBackend skdb_e)
    {
        List<unowned Gtk.ComboBox> matching = null;
        Gtk.VBox import_page = null;
        this.skdb = skdb_e;
        Gtk.ComboBox schema_selection = null;
        /* Setup schemas */
        List<unowned DataSchema> ss = skdb.get_schemas();
        foreach(DataSchema s in ss) {
            TreeIter iter;
            schemas.insert_with_values(out iter, 0, 0, s, 1, s.get_title(), 2,s.get_pixbuf());
        }
        /* TODO: watch for schema changes on the DataBackend */

        /* The type of data page */
        {
            var vbox_select_type = new Gtk.VBox(false, 0);

            var label = new Gtk.Label("Select type of item to import:");
            label.set_alignment(0.0f, 0.5f);
            vbox_select_type.pack_start(label, false, true, 0);
            /* Create combo box where user can select the type */
            schema_selection = new Gtk.ComboBox.with_model(schemas);
            vbox_select_type.pack_start(schema_selection, false, true, 0);
            /* show the icon in the view */
            var renderer = new Gtk.CellRendererPixbuf();
            schema_selection.pack_start(renderer, false);
            schema_selection.add_attribute(renderer, "pixbuf", 2);
            /* Show the text */
            var renderer2 = new Gtk.CellRendererText();
            schema_selection.pack_start(renderer2, true);
            schema_selection.add_attribute(renderer2, "text", 1);
            
            /* If user selected a type, unlock the next page */
            schema_selection.changed.connect((source) => {
                TreeIter iter;
                if(source.get_active_iter(out iter)){
                    schemas.get(iter, 0, out schema); 
                    ass.set_page_complete(vbox_select_type, true);
                } else {
                    schema = null;
                    ass.set_page_complete(vbox_select_type, false);
                }
            });

            ass.append_page(vbox_select_type);
            ass.set_page_title(vbox_select_type, "Select type");
            ass.set_page_complete(vbox_select_type, false);
            vbox_select_type.show_all();
        }

        /* Input page */
        {
            /* Entry box and Check button */
            var file_entry = new Gtk.Entry();
            var v = new Gtk.VBox(false, 6);

            v.pack_start(file_entry, false, true, 0);
            var check_button = new Gtk.Button.from_stock(Gtk.STOCK_APPLY);
            v.pack_start(check_button, false, true, 0);
            /**
             * Read the file content and feed it to the parser 
             */
            check_button.clicked.connect((source) => {
                string a = file_entry.get_text();
                if(a.length > 0) {
                    try {
                        string contents;
                        size_t size;
                        GLib.FileUtils.get_contents(a, out contents, out size);
                        stdout.printf("%s\n", contents); 
                        try{
                        p = new ItemParser(contents);
                        }catch (Error e) {
                            GLib.warning("Failed to create parser: %s\n", e.message);
                            p = null;
                        }
                    }catch(Error e) {
                        GLib.warning("Failed to open file: %s", e.message);
                        p = null;
                    }
                }else{
                    p = null;
                }
                if(p != null){
                    ass.set_page_complete(v, true);
                }else{
                    ass.set_page_complete(v, false);
                }
            });

            v.show_all();
            ass.append_page(v);
            ass.set_page_title(v, "Select input");
            ass.set_page_complete(v, false);
        }

        /* Import page */
        {
            import_page = new Gtk.VBox(false, 0);


            import_page.show();
            ass.append_page(import_page);
            ass.set_page_title(import_page, "Import");
            ass.set_page_complete(import_page, false);
            ass.set_page_type(import_page, Gtk.AssistantPageType.CONFIRM);
        }
        ass.prepare.connect((source, page) => {
            /* Clear previous matching tables */
            matching = null;

            if(page == import_page) {
                /* Allow the user to finish te page */
                ass.set_page_complete(import_page, true);

                GLib.debug("hitting the import page\n");
                /* Create model with entries from parser */
                var model = new Gtk.ListStore(1, typeof(string));
                foreach(string a in p.get_fields()) {
                    TreeIter iter;
                    model.insert_with_values(out iter, 0, 0, a);
                }

                /* we want to create the page here: */
                var sg = new Gtk.SizeGroup(Gtk.SizeGroupMode.HORIZONTAL);
                string[] fields = schema.get_fields();
                foreach(string field in fields)
                {
                    var type = schema.get_field_type(field);
                    if(type != FieldType.STRING && type != FieldType.INTEGER && type != FieldType.BOOLEAN 
                        && type != FieldType.RATING && type != FieldType.TEXT && type != FieldType.LINK) continue;
                    var hb = new Gtk.HBox(false, 6);
                    var label = new DataLabel.schema_field(schema, field);
                    hb.pack_start(label, false, true, 0);
                    sg.add_widget(label);

                    /* Selection box */
                    var combo = new Gtk.ComboBox.with_model(model);
                    var renderer_t = new Gtk.CellRendererText();
                    combo.pack_start(renderer_t, true);
                    combo.add_attribute(renderer_t, "text", 0);
                    hb.pack_start(combo, true, true, 0);

                    import_page.pack_start(hb, false, true, 0);

                    combo.set_data_full("field-id", (void *)field.dup(), g_free);
                    matching.prepend(combo);
                }

                import_page.show_all();
            }else{
                GLib.debug("not the import page\n");
                ass.set_page_complete(import_page, false);
                foreach(Gtk.Widget child in import_page.get_children()) {
                    child.destroy();
                }

            }
        });

        ass.cancel.connect((source)=>{ ass.destroy();stdout.printf("cancel\n");destroy_requested(); });
        
        ass.apply.connect((source)=>
        {
            stdout.printf("apply\n");
            var item = skdb.new_item(schema);
            foreach(Gtk.ComboBox combo in matching) 
            {
                    TreeIter iter;
                    string field_id = combo.get_data("field-id");
                    var type = schema.get_field_type(field_id);
                    if(combo.get_active_iter(out iter))
                    {
                        string field = null;
                        combo.get_model().get(iter, 0, out field);
                        string value = p.get_value(field);
                        if(type == FieldType.STRING || type == FieldType.INTEGER 
                            || type == FieldType.RATING || type == FieldType.TEXT || type == FieldType.LINK){
                            item.set_string(field_id, value);
                        }else if (type == FieldType.BOOLEAN) {
                            if(value == "true" || value == "1" || value == "yes" || value == "TRUE" || value == "YES") {
                                item.set_boolean(field_id, true);
                            }else{
                                item.set_boolean(field_id, false);
                            }
                        }
                    }
            }

            destroy_requested(); 
        });
        ass.close.connect((source)=>
        { 
            ass.destroy();stdout.printf("close\n");destroy_requested(); 
        }
        );

        /* Run */
        ass.show_all();

    }

    ~GenericInputDialog()
    {
        stdout.printf("Destroy\n");
        ass = null;
    }

    public signal void destroy_requested();

}


public class GenericInput : Stuffkeeper.Plugin {

    construct{
    }
	public override PluginType get_plugin_type()
	{
		return PluginType.MENU;
	}

	public override unowned string get_name()
	{
		return "Generic Input";
	}

	public override void run_menu(Stuffkeeper.DataBackend skdb_e)
	{
        /* Quick hack to make sure it does not get destroyed to early */
        var a = new GenericInputDialog(skdb_e);

        a.destroy_requested.connect((source) => {
            stdout.printf("Destroy\n");
            a = null;
        });

	}

	/* Destruction */
	~Test ()
	{
	}

}

[ModuleInit]
public GLib.Type register_plugin()
{
    return typeof(GenericInput);
}
