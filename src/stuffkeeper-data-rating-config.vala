using GLib;
using Gtk;
using Stuffkeeper;

public class Stuffkeeper.DataRatingConfig : Gtk.Table {
	private string field = null;
	private DataSchema schema = null;
	private Gtk.SpinButton min_spin = null;
	private Gtk.SpinButton max_spin = null;
	private Gtk.SpinButton default_spin = null;
	private uint update_timeout = 0;

	public enum CustomFields  {
		MIN_RANGE = 0,
		MAX_RANGE = 1,
		DEFAULT_VALUE = 2
	}

	/**
	 * Listen to changes to this field
	 */
	private void field_changed(DataSchema schema, string id, int field)
	{
		if(field == CustomFields.MIN_RANGE)
		{
			int value = 0;
			if(schema.get_custom_field_integer(id, field, out value))
			{
				if(min_spin.value != (double)value)
				{
					min_spin.value_changed -= spin_changed;		
					min_spin.value = (double)value;	
					max_spin.set_range(min_spin.value+1, int.MAX);
                    default_spin.set_range((double)value, max_spin.value);
					min_spin.value_changed += spin_changed;					
				}
			}
		}	

		if(field == CustomFields.MAX_RANGE)
		{
			int value = 0;
			if(schema.get_custom_field_integer(id, field, out value))
			{
				if(max_spin.value != (double)value)
				{
					max_spin.value_changed -= spin_changed;		
					max_spin.value = (double)value;	
					min_spin.set_range(int.MIN, max_spin.value-1);
                    default_spin.set_range(min_spin.value, (double)value);
					max_spin.value_changed += spin_changed;					
				}
			}
		}	
        if(field == CustomFields.DEFAULT_VALUE)
        {
			int value = 0;
			if(schema.get_custom_field_integer(id, field, out value))
			{
				if(default_spin.value != (double)(value/10.0))
				{
					default_spin.value_changed -= spin_changed;		
					default_spin.value = (double)value/10.0;	
					default_spin.value_changed += spin_changed;					
				}
			}
		}
	}
	private 
	bool
	save_changes()
	{
		update_timeout =0;
		double value = 0.0;
		stdout.printf("Save changes\n");	
		value = min_spin.value;
		schema.set_custom_field_integer(field, CustomFields.MIN_RANGE, (int)value);
		value = max_spin.value;
		schema.set_custom_field_integer(field, CustomFields.MAX_RANGE, (int)value);

		value = default_spin.value;
		schema.set_custom_field_integer(field, CustomFields.DEFAULT_VALUE, (int)(value*10));
		return false;
	}

	/**
	 * Listen to clicks
	 */	

	/**
	 * Destruction 
	 */
	~DataRatingConfig() {
		stdout.printf("Dispose\n");

		/* This gets called twice.. 
		 * Hack it to have it run only once*/
			schema.schema_custom_field_changed -= field_changed;
			if(update_timeout > 0)
			{
                stdout.printf("force saving\n");
				Source.remove(update_timeout);
				update_timeout = 0;
				save_changes();	
			}
        stdout.printf("kdispose_done\n");
	}
	/**
	 * Construct 
	 */

	/* handle updates */
	private void spin_changed(SpinButton spin)
	{
        stdout.printf("value changed\n");
        /* force update */
		//spin.update();
		min_spin.set_range(int.MIN, max_spin.value-1);
		max_spin.set_range(min_spin.value+1, int.MAX);
        default_spin.set_range(min_spin.value, max_spin.value);
        if(update_timeout > 0)
		{
			Source.remove(update_timeout);	
		}
		update_timeout = Timeout.add_seconds(1, save_changes);
	}


	construct {
		this.set_row_spacings(6);
		this.set_col_spacings(6);

		var label = new Gtk.Label("Minimum value");
		label.set_alignment(1.0f,0.5f);
		min_spin = new Gtk.SpinButton.with_range(int.MIN, int.MAX, 1);
		min_spin.numeric= true;
		this.attach(label, 0,1,0,1,
					AttachOptions.SHRINK|AttachOptions.FILL,
					AttachOptions.SHRINK,0,0);
		this.attach(min_spin, 1,2,0,1,
					AttachOptions.SHRINK|AttachOptions.FILL,
					AttachOptions.SHRINK,0,0);

		min_spin.value =  0.0;
		min_spin.value_changed += spin_changed;

		label = new Gtk.Label("Maximum value");
		label.set_alignment(1.0f,0.5f);

		max_spin = new Gtk.SpinButton.with_range(int.MIN, int.MAX, 1);
		max_spin.numeric= true;

		this.attach(label, 0,1,1,2,
				AttachOptions.SHRINK|AttachOptions.FILL,
				AttachOptions.SHRINK,0,0);
		this.attach(max_spin, 1,2,1,2,
				AttachOptions.SHRINK|AttachOptions.FILL,
				AttachOptions.SHRINK,0,0);
		max_spin.value = 10.0;
		max_spin.value_changed += spin_changed;

        label = new Gtk.Label("Default value");
		label.set_alignment(1.0f,0.5f);

		default_spin = new Gtk.SpinButton.with_range(int.MIN, int.MAX,0.1);
		default_spin.numeric= true;

		this.attach(label, 0,1,2,3,
				AttachOptions.SHRINK|AttachOptions.FILL,
				AttachOptions.SHRINK,0,0);
		this.attach(default_spin, 1,2,2,3,
				AttachOptions.SHRINK|AttachOptions.FILL,
				AttachOptions.SHRINK,0,0);
		default_spin.value = 5.0;
		default_spin.value_changed += spin_changed;


		this.show_all();
	}

	/**
	 * Set it up 
	 */
	public void setup (Stuffkeeper.DataSchema schema, string fid) {
		this.schema = schema;
		this.field = fid;

		/* update all the boxes */
		field_changed(schema,field, CustomFields.MIN_RANGE);
		field_changed(schema,field, CustomFields.MAX_RANGE);
		field_changed(schema,field, CustomFields.DEFAULT_VALUE);

		/* connect signals */
		schema.schema_custom_field_changed += field_changed;
	}

}
