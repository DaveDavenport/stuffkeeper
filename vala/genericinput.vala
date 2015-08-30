/*

*/
using GLib;
using Gtk;
using Stuffkeeper;

errordomain ItemParserDataError {
    NO_UTF8,
    INVALID_STRUCTURE,
    DUPLICATE_ENTRIES
}

/* The separator used */
const string Separator = "::";
const string ItemSeparator = "<EOI>";
const string ListSeparator = ";";
/**
 * Executes a script and puts the output in a string
 */
private string? execute_script(string commandline) throws SpawnError
{
    string output, error;
    try{
        if(Process.spawn_command_line_sync(commandline, out output, out error))
        {
            return output;
        }
    }catch (SpawnError e) {
        throw e;
    }
    return null;
}


/**
 * Parse multiple items in a file
 * Foreach item a ItemParser is created.
 * It also keeps a list of unique fields.
 * Items are separated by "<EOI>";
 */
private class Parser
{
    private List<ItemParser> items = null;
    private List<string> fields = null;

    public Parser(string data) throws ItemParserDataError
    {
        /* Split data into lines */
        string[] entries = data.split(ItemSeparator,-1);
        foreach(string entry in entries)
        {
            try {
                debug("New item :%s", entry);
                /* Create new item */
                var pi = new ItemParser(entry);
                if(pi.num_items() > 0)
                {
                    items.prepend(pi);
                }
            }catch (ItemParserDataError e) {
                /* Fallthrough error */
                throw e;
            }
        }
        /**
         * Collect list of unique fields (inefficient)
         * Might want to use some fast lookup table here..
         */
        foreach(ItemParser p in items) {
            List<weak string> fds = p.get_fields();
            foreach(string field in fds)
            {
                if(fields.find_custom(field, strcmp) == null)
                {
                    fields.prepend(field);
                }
            }
        }
    }
    public List<unowned string> get_fields()
    {
        return fields.copy();
    }
    public List<weak ItemParser> get_items()
    {
        return items.copy();
    }
    public uint num_items()
    {
        return items.length();
    }

}

/**
 * Data format:
 * * Contains data for 1 item.
 * * There is one entry per line (matching a entry in the type)
 * * The line is  <field>::<data>
 *   * <field> is simple alfanumeric.
 *   * <field> is unique,
 *   * <data> is simple string where newline is escaped. \n
 *    * <data> is type list, then ; is separator.
 *   * All input data is valid utf-8!
 *   * Boolean data are (for true):  YES, yes, 1, true, TRUE
 */
private class ItemParser {
    /* The key pair combination */
    private GLib.HashTable<string, string> values = new HashTable<string, string>.full(str_hash, str_equal, g_free, g_free);

    public uint num_items()
    {
        return values.size();
    }


    /* Take the input string and parse it. */
    public ItemParser(string data) throws ItemParserDataError
    {
        /* Validate if the input data is utf8 */
        if(!data.validate())
        {
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
                string a = values.lookup(entries[0]);
                string b = a+";"+entries[1]; 
                values.remove(entries[0]);
                values.insert(entries[0], b);

      /*          throw new ItemParserDataError.DUPLICATE_ENTRIES("Input data contained duplicate entries: %s", line);*/
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
private class GenericInputDialog:Gtk.Assistant
{
    private DataSchema schema = null;
    private Gtk.ListStore schemas = new Gtk.ListStore(3,typeof(DataSchema),typeof(string), typeof(Gdk.Pixbuf));
    private Parser p = null;
    private List<unowned Gtk.ComboBox> matching = null;
    private DataBackend skdb = null;
    private Gtk.VBox import_page = null;

    public void setup(DataBackend skdb_e)
    {
        skdb = skdb_e;
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
                    this.set_page_complete(vbox_select_type, true);
                } else {
                    schema = null;
                    this.set_page_complete(vbox_select_type, false);
                }
            });

            this.append_page(vbox_select_type);
            this.set_page_title(vbox_select_type, "Select type");
            this.set_page_complete(vbox_select_type, false);
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
            var execute_button = new Gtk.Button.with_label("Execute");
            v.pack_start(execute_button, false, true, 0);
            execute_button.clicked.connect((source) => {
                string a = file_entry.get_text();
                if(a.length > 0) {
                    try {
                        string contents = execute_script(a);
                        stdout.printf("%s\n", contents);
                        try{
                        p = new Parser(contents);
                        }catch (Error e) {
                            GLib.warning("Failed to create parser: %s\n", e.message);
                            var md = new MessageDialog(this, Gtk.DialogFlags.MODAL,Gtk.MessageType.WARNING, Gtk.ButtonsType.CLOSE, "Failed to create parser: %s", e.message);
                            md.run(); md.destroy();
                            p = null;
                        }
                    }catch(Error e) {
                        GLib.warning("Failed to execute file: %s", e.message);
                            var md = new MessageDialog(this, Gtk.DialogFlags.MODAL,Gtk.MessageType.WARNING, Gtk.ButtonsType.CLOSE, "Failed to execute script: %s", e.message);
                            md.run(); md.destroy();
                        p = null;
                    }
                }else{
                    p = null;
                }
                if(p != null){
                    this.set_page_complete(v, true);
                }else{
                    this.set_page_complete(v, false);
                }
            });
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
                        p = new Parser(contents);
                        }catch (Error e) {
                            GLib.warning("Failed to create parser: %s\n", e.message);
                            var md = new MessageDialog(this, Gtk.DialogFlags.MODAL,Gtk.MessageType.WARNING, Gtk.ButtonsType.CLOSE, "Failed to create parser: %s", e.message);
                            md.run(); md.destroy();
                            p = null;
                        }
                    }catch(Error e) {
                        GLib.warning("Failed to open file: %s", e.message);
                        var md = new MessageDialog(this, Gtk.DialogFlags.MODAL,Gtk.MessageType.WARNING, Gtk.ButtonsType.CLOSE, "Failed to open file: %s", e.message);
                        md.run(); md.destroy();
                        p = null;
                    }
                }else{
                    p = null;
                }
                if(p != null){
                    this.set_page_complete(v, true);
                }else{
                    this.set_page_complete(v, false);
                }
            });

            v.show_all();
            this.append_page(v);
            this.set_page_title(v, "Select input");
            this.set_page_complete(v, false);
        }

        /* Import page */
        {
            import_page = new Gtk.VBox(false, 0);


            import_page.show();
            this.append_page(import_page);
            this.set_page_title(import_page, "Import");
            this.set_page_complete(import_page, false);
            this.set_page_type(import_page, Gtk.AssistantPageType.CONFIRM);
        }

        /* Run */
        this.show_all();

    }

    public override void prepare (Gtk.Widget page)
    {
        /* Clear previous matching tables */
        matching = null;

        if(page == import_page) {
            /* Allow the user to finish te page */
            this.set_page_complete(import_page, true);

            GLib.debug("hitting the import page\n");
            /* Create model with entries from parser */
            var model = new Gtk.ListStore(2, typeof(string), typeof(int));
            foreach(string a in p.get_fields()) {
                TreeIter iter;
                model.insert_with_values(out iter, 0, 0, a, 1,1);
            }
            TreeIter iter;
            model.insert_with_values(out iter, 0, 0, "n/a", 1,  0);

            /* we want to create the page here: */
            var sg = new Gtk.SizeGroup(Gtk.SizeGroupMode.HORIZONTAL);
            string[] fields = schema.get_fields();
            foreach(string field in fields)
            {
                var type = schema.get_field_type(field);
                if(type != FieldType.STRING && type != FieldType.INTEGER && type != FieldType.BOOLEAN
                        && type != FieldType.RATING && type != FieldType.TEXT && type != FieldType.LINK
                        && type != FieldType.LIST && type != FieldType.FILES && type != FieldType.DATE) continue;
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
                combo.set_active_iter(iter);
                TreeIter piter;
                if(model.get_iter_first(out piter)) {
                    do{
                        string a;
                        int skip=0;
                        model.get(piter, 0, out a, 1, out skip);
                        if (skip == 1 &&  a.down().collate(schema.get_field_name(field).down()) == 0) {
                            combo.set_active_iter(piter);
                        }
                    }while(model.iter_next(ref piter));
                }
                combo.set_data_full("field-id", (void *)field.dup(), g_free);
                matching.prepend(combo);
            }

            import_page.show_all();
        }else{
            GLib.debug("not the import page\n");
            this.set_page_complete(import_page, false);
            foreach(Gtk.Widget child in import_page.get_children()) {
                child.destroy();
            }

        }
    }
    public override void close()
    {
        stdout.printf("close\n");
        this.cancel();
    }

    public override void cancel()
    {
        stdout.printf("cancel\n");
        /* Hack to break the ref cycle */
        this.get_nth_page(2).destroy();
        this.get_nth_page(1).destroy();
        this.get_nth_page(0).destroy();
        this.destroy();
    }
    public override void apply()
    {
        debug("Apply()");
        foreach(ItemParser ip in p.get_items())
        {
            var item = skdb.new_item(schema);
            foreach(Gtk.ComboBox combo in matching)
            {
                TreeIter iter;
                string field_id = (string)combo.get_data<string>("field-id");
                var type = schema.get_field_type(field_id);
                if(combo.get_active_iter(out iter))
                {
                    string field = null;
                    int skip = 0;
                    combo.get_model().get(iter, 0, out field, 1,out skip);
                    /* Skip if it is N/A */
                    if(skip == 0) continue;

                    string value = ip.get_value(field);
                    /* Skip if no value */
                    if(value == null) continue;
                    /* Parse string/integer type. (sqlite will do conversion when displaying */
                    if(type == FieldType.STRING || type == FieldType.INTEGER
                            || type == FieldType.RATING || type == FieldType.TEXT || type == FieldType.LINK){
                        item.set_string(field_id, value);
                    /* Parse boolean type */
                    }else if (type == FieldType.BOOLEAN) {
                        if(value == "true" || value == "1" || value == "yes" || value == "TRUE" || value == "YES") {
                            item.set_boolean(field_id, true);
                        }else{
                            item.set_boolean(field_id, false);
                        }
                    /* Parse list or files (uses same data type ) */
                    }else if (type == FieldType.LIST || type == FieldType.FILES) {
                            string[] list = value.split(ListSeparator, -1);
                            item.set_list(field_id,list);
                    /* Parse date using glib's Date function */
                    } else if (type == FieldType.DATE) {
                            Date  d = Date();
                            d.set_parse(value);
                            if(d.valid()) {
                                Time tm;
                                d.to_time(out tm);
                                item.set_integer(field_id, (int)tm.mktime());
                            }
                    }
                }
            }
        }
    }

    ~GenericInputDialog()
    {
        stdout.printf("Destroy object callback\n");
    }


}


public class GenericInput : Stuffkeeper.Plugin
{
    construct {

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
        if(skdb_e.get_locked())
        {

            var md = new MessageDialog(null,
                    Gtk.DialogFlags.MODAL,Gtk.MessageType.INFO, Gtk.ButtonsType.CLOSE,
                    "You cannot import items if the database is locked.");
            md.run(); md.destroy();
            return;
        }
        /* Quick hack to make sure it does not get destroyed to early */
        var a = new GenericInputDialog();
        a.setup(skdb_e);
	}

	/* Destruction */
	~GenericInput ()
	{
        debug("Generic Input destroy");
	}

    public override Gdk.Pixbuf? get_icon()
    {
        return null;
    }
}

//[ModuleInit]
public Type register_plugin(Module module)
{
    return typeof(GenericInput);
}
