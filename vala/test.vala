using GLib;
using Gtk;
using Stuffkeeper;

public class Test : Stuffkeeper.Plugin {
	private Dialog win;

	public override PluginType get_plugin_type()
	{
		return PluginType.MENU;
	}

	public override weak string get_name()
	{
		return "Tag Cloud";
	}

	public override void run_menu(Stuffkeeper.DataBackend skdb)
	{
		this.show_window(skdb);
	}

	/* Destruction */
	~Test ()  
	{
		/* if the response window is still open, close it.. */
		if(win != null)
		{
			response_window(win, 0);
		}
	}

	/**
	 * Show window 
	 */
	static int tag_compare(DataTag tag1, DataTag tag2)
	{
		return tag1.get_title().collate(tag2.get_title()); 	
	}
	private string generate_cloud(Stuffkeeper.DataBackend skdb, Gtk.VBox box)
	{
		string str = new string();
		List<weak DataTag> list = skdb.get_tags();
		double max = -1;


		list.sort((GLib.CompareFunc)tag_compare);
		/* Get the max size */
		foreach (DataTag item in list){
			double items = item.num_items();
			if(items > max) {
				max = items; 
			}
		}
		/* no max item, is no item found, so skip it, nothing to draw. */
		if(max <= 0.0) 
			return str;

		Gtk.HBox hbox  = null;
		int max_width = 	600;
		int cur_size = 0;
		foreach (DataTag item in list){
			double items = item.num_items()+1;
			if(items > 1)
			{
				Requisition req;
				double scaled = Math.pow(items/max,0.5);
				var lab =  new Label (item.get_title());
				lab.set_markup("<span size='%.0f'>%s</span> ".printf (48*1024*(scaled),Markup.escape_text(item.get_title(),-1)));
				lab.size_request(req);

				/* check if it still fits, if it doesn't create a new row */
				if(cur_size+req.width > max_width || hbox == null)
				{
					var ali = new Gtk.Alignment(0.5f,0.5f,0.0f,0.0f);
					hbox  = new Gtk.HBox(false,0);
					ali.add(hbox);
					box.pack_start(ali, true,true,0);
					cur_size = 0;
				}	
				hbox.pack_start(lab, false, false,0);
				cur_size += req.width;
			}
		}
		return str;
	}
	private void show_window(Stuffkeeper.DataBackend skdb)
	{
		/* if window is already open, do nothing */
		if(win != null)
		{
			win.present();
			return;
		}
		/* create dialog */
		win = new Dialog ();
		win.title = "Tag cloud";
		win.add_buttons(Gtk.STOCK_CLOSE, ResponseType.CLOSE);

		/* Generate the cloud */
		generate_cloud(skdb, win.vbox); 

		win.response += this.response_window;
		win.show_all();
	}

	private void response_window(Dialog dialog, int resonse_id)
	{
		win.destroy();

		stdout.printf("Close window\n");
		win = null;
	}
}

[ModuleInit]
public GLib.Type register_plugin()
{
    return typeof(Test);
}
