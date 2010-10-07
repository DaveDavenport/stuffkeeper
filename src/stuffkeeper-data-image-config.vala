using GLib;
using Gtk;
using Stuffkeeper;

public class Stuffkeeper.DataImageConfig : Gtk.HBox {
	private string field = null;
	private DataSchema schema = null;
	private Gtk.SpinButton spinbutton = null;
	/* hack to fix vala bug */
	static bool quit = false;
	private enum PrivateField {
		IMAGE_SIZE = 0;
	}

	/**
	 * Listen to changes to this field
	 */
	private void field_changed(DataSchema schema, string id, int field)
	{
		if(field == (int)PrivateField.IMAGE_SIZE)
		{
			int value = 0;
			if(schema.get_custom_field_integer(id, PrivateField.IMAGE_SIZE, out value))
			{
				if(spinbutton.value != value)
				{
					//schema.schema_custom_field_changed -= field_changed;
					this.spinbutton.value_changed.disconnect(toggled);	
					spinbutton.value = value;	
					//schema.schema_custom_field_changed += field_changed;
					this.spinbutton.value_changed.connect(toggled);
				}
			}
		}	
	}

	/**
	 * Listen to clicks
	 */	
	private void toggled(Gtk.SpinButton spinbutton)
	{
		int value = (int)spinbutton.value;
		schema.set_custom_field_integer(field,PrivateField.IMAGE_SIZE,value);
	}

	/**
	 * Destruction 
	 */
	~DataImageConfig() {
		stdout.printf("Dispose data boolean config\n");

		/* This gets called twice.. 
		 * Hack it to have it run only once*/
		if(!quit)
		{
			schema.schema_custom_field_changed.disconnect(field_changed);
		}
		quit = true;
	}
	/**
	 * Construct 
	 */
	construct {
		var label = new Gtk.Label("Default value");
		this.spinbutton = new Gtk.SpinButton.with_range(8, 4192,4);

		this.pack_start(label, false, false,0);
		this.pack_start(spinbutton, true, true,0);
		this.show_all();
	}

	/**
	 * Set it up 
	 */
	public void setup (Stuffkeeper.DataSchema schema, string fid) {
		int value;
		this.schema = schema;
		this.field = fid;

		if(schema.get_custom_field_integer(field, PrivateField.IMAGE_SIZE, out value))
		{
			this.spinbutton.value = value;
		}
		else this.spinbutton.value = 250;
		/* connect signals */
		this.spinbutton.value_changed.connect(toggled);	
		schema.schema_custom_field_changed.connect(field_changed);
	}

}
