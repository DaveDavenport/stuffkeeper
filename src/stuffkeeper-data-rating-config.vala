using GLib;
using Gtk;
using Stuffkeeper;

public class Stuffkeeper.DataRatingConfig : Gtk.Table {
	private string field = null;
	private DataSchema schema = null;
	private Gtk.SpinButton min_spin = null;
	private Gtk.SpinButton max_spin = null;
	private Gtk.SpinButton step_spin= null;
	private uint update_timeout = 0;

	public enum CustomFields  {
		MIN_RANGE,
		MAX_RANGE,
		STEP_RANGE,
		DEFAULT_VALUE	
	}

	/* hack to fix vala bug */
	static bool quit = 0;

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
					min_spin.changed -= min_spin_changed;		
					min_spin.value = (double)value;	
					max_spin.set_range(min_spin.value, int.MAX);
					min_spin.changed += min_spin_changed;					
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
					max_spin.changed -= max_spin_changed;		
					max_spin.value = (double)value;	
					min_spin.set_range(int.MIN, max_spin.value);
					max_spin.changed += max_spin_changed;					
				}
			}
		}	
		if(field == CustomFields.STEP_RANGE)
		{
			int value = 0;
			if(schema.get_custom_field_integer(id, field, out value))
			{
				if(step_spin.value != (double)(value/10.0))
				{
					step_spin.changed -= step_spin_changed;		
					step_spin.value = (double)value/10.0;	
					step_spin.changed += step_spin_changed;					
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
		value = step_spin.value*10;
		schema.set_custom_field_integer(field, CustomFields.STEP_RANGE,(int)value);

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
		if(!quit)
		{
			schema.schema_custom_field_changed -= field_changed;
			if(update_timeout > 0)
			{
				Source.remove(update_timeout);
				update_timeout = 0;
				save_changes();	
			}
		}
		quit = true;
	}
	/**
	 * Construct 
	 */
	private void min_spin_changed(SpinButton spin)
	{
		/* force update */
		min_spin.update();
		max_spin.set_range(min_spin.value, int.MAX);
		if(update_timeout > 0)
		{
			Source.remove(update_timeout);	
		}
		update_timeout = Timeout.add_seconds(1, save_changes);
	}
	/* handle updates */
	private void max_spin_changed(SpinButton spin)
	{
		/* force update */
		max_spin.update();
		min_spin.set_range(int.MIN, max_spin.value);
		if(update_timeout > 0)
		{
			Source.remove(update_timeout);	
		}
		update_timeout = Timeout.add_seconds(1, save_changes);
	}
	/* handle updates */
	private void step_spin_changed(SpinButton spin)
	{
		/* force update */
		step_spin.update();
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
		min_spin = new Gtk.SpinButton.with_range(int.MIN, int.MAX, 1);
		this.attach(label, 0,1,0,1,AttachOptions.SHRINK|AttachOptions.FILL, AttachOptions.SHRINK,0,0);
		this.attach(min_spin, 1,2,0,1,AttachOptions.SHRINK|AttachOptions.FILL, AttachOptions.SHRINK,0,0);
		min_spin.value =  (double)int.MIN;
		min_spin.changed += min_spin_changed;

		label = new Gtk.Label("Maximum value");
		max_spin = new Gtk.SpinButton.with_range(int.MIN, int.MAX, 1);
		this.attach(label, 0,1,1,2,AttachOptions.SHRINK|AttachOptions.FILL, AttachOptions.SHRINK,0,0);
		this.attach(max_spin, 1,2,1,2,AttachOptions.SHRINK|AttachOptions.FILL, AttachOptions.SHRINK,0,0);
		max_spin.value =  (double)int.MAX;
		max_spin.changed += max_spin_changed;

		label = new Gtk.Label("Step size");
		step_spin = new Gtk.SpinButton.with_range(0, int.MAX, 0.1);
		this.attach(label, 0,1,2,3,AttachOptions.SHRINK|AttachOptions.FILL, AttachOptions.SHRINK,0,0);
		this.attach(step_spin, 1,2,2,3,AttachOptions.SHRINK|AttachOptions.FILL, AttachOptions.SHRINK,0,0);
		step_spin.value = 1.0;
		step_spin.changed += step_spin_changed;


		this.show_all();
	}

	/**
	 * Set it up 
	 */
	public void setup (Stuffkeeper.DataSchema schema, string fid) {
		int value;
		this.schema = schema;
		this.field = fid;

		field_changed(schema,field, CustomFields.MIN_RANGE);
		field_changed(schema,field, CustomFields.MAX_RANGE);
		field_changed(schema,field, CustomFields.STEP_RANGE);



		/* connect signals */
		schema.schema_custom_field_changed += field_changed;
	}

}
