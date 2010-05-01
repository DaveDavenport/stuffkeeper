using GLib;
using Gtk;
using Stuffkeeper;

errordomain ParserDataError {
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
 */
private class Parser {
    /* The key pair combination */
    private GLib.HashTable<string, string> values = new HashTable<string, string>.full(str_hash, str_equal, g_free, g_free);


    /* The separator used */
    private const string Separator = "::";


    /* Take the input string and parse it. */
    public Parser(string data) throws ParserDataError
    {
        /* Validate if the input data is utf8 */
        if(!data.validate())
        {
            /* Make this an GError, with trowing errors and so */
            throw new ParserDataError.NO_UTF8("Input data is not valid utf8");              
        }


        /* Split data into lines */
        string[] lines = data.split("\n",-1);


        /* Parse each line */
        foreach(string line in lines)
        {
            /* Split the line on the separator */
            string[] entries = line.split(Separator, 2);
            /* If the line does not consist of 2 entries, we bail out and throw an error. */
            if(entries.length != 2) {
                throw new ParserDataError.INVALID_STRUCTURE("Input data has invalid structure");              
            }
            /* Insert into hash key */
            if(!values.lookup_extended(entries[0], null, null)){
                values.insert(entries[0], entries[1]);
            }else{
                throw new ParserDataError.DUPLICATE_ENTRIES("Input data contained duplicate entries");        
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
    public GenericInputDialog(DataBackend skdb_e)
    {
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

            var v = new Gtk.VBox(false, 0);

            v.show();
            ass.append_page(v);
            ass.set_page_title(v, "Select input");
            ass.set_page_complete(v, true);
        }

        /* Import page */
        {
            var v = new Gtk.VBox(false, 0);


            v.show();
            ass.append_page(v);
            ass.set_page_title(v, "Import");
        }

        ass.cancel.connect((source)=>{ ass.destroy();stdout.printf("cancel\n");destroy_requested(); });
        
        ass.apply.connect((source)=>{ ass.destroy();stdout.printf("apply\n");destroy_requested(); });
        ass.close.connect((source)=>{ ass.destroy();stdout.printf("close\n");destroy_requested(); });

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
        /* Testing code */
        try{
            Parser p = new Parser("aap::noot\\nnew line\nnoot::mies\nmies::aap");

            List<unowned string> items = p.get_fields();
            foreach (string a in items) 
            {
                stdout.printf("key: %s value: %s\n", a, p.get_value(a));
            }
        }catch (Error e) {
            stdout.printf("Failed to parse file: %s\n", e.message);
        }

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
