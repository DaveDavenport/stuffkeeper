using GLib;
using Gtk;
using Stuffkeeper;

public class Stuffkeeper.DataBooleanConfig : Gtk.HBox {
	private string field = null;
	private DataSchema schema = null;
	private Gtk.CheckButton checkbox = null;
	/* hack to fix vala bug */
	static bool quit = false;

	/**
	 * Listen to changes to this field
	 */
	private void field_changed(DataSchema schema, string id, int field)
	{
		if(field == 0)
		{
			int value = 0;
			if(schema.get_custom_field_integer(id, 0, out value))
			{
				if(checkbox.active != (bool)value)
				{
					//schema.schema_custom_field_changed -= field_changed;
					this.checkbox.toggled += toggled;	
					checkbox.active = (bool)value;	
					//schema.schema_custom_field_changed += field_changed;
					this.checkbox.toggled += toggled;	
				}
			}
		}	
	}

	/**
	 * Listen to clicks
	 */	
	private void toggled(Gtk.ToggleButton toggle)
	{
		if(toggle.active)
		{
			schema.set_custom_field_integer(field,0,1);
		}else{
			schema.set_custom_field_integer(field,0,0);
		}
	}

	/**
	 * Destruction 
	 */
	~DataBooleanConfig() {
		stdout.printf("Dispose data boolean config\n");

		/* This gets called twice.. 
		 * Hack it to have it run only once*/
		if(!quit)
		{
			schema.schema_custom_field_changed -= field_changed;
		}
		quit = true;
	}
	/**
	 * Construct 
	 */
	construct {
		var label = new Gtk.Label("Default value");
		this.checkbox = new Gtk.CheckButton();

		this.pack_start(label, false, false,0);
		this.pack_start(checkbox, true, true,0);
		this.show_all();
	}

	/**
	 * Set it up 
	 */
	public void setup (Stuffkeeper.DataSchema schema, string fid) {
		int value;
		this.schema = schema;
		this.field = fid;

		if(schema.get_custom_field_integer(field, 0, out value))
		{
			this.checkbox.active = (bool)value;
		}
		/* connect signals */
		this.checkbox.toggled += toggled;	
		schema.schema_custom_field_changed += field_changed;
	}

}
