using GLib;
using Gtk;
using Stuffkeeper;

public class Test : Stuffkeeper.Plugin {
	private Dialog win;
	private long signal = 0;
	private DataBackend skdb = null;

    construct{
    }
	public override PluginType get_plugin_type()
	{
		return PluginType.MENU;
	}

	public override unowned string get_name()
	{
		return "Tag Cloud";
	}

	public override void run_menu(Stuffkeeper.DataBackend skdb_e)
	{
		this.show_window(skdb_e);
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
	private string generate_cloud(Stuffkeeper.DataBackend skdb_e, Gtk.VBox box)
	{
		string str = "";
		List<unowned DataTag> list = skdb_e.get_tags();
		double max = -1;

		/**
		 * THIS NEEDS TO BE FIXED, BUG IN GTK VAPI FILE!
	   */
		List<unowned Widget> children = box.get_children();
		foreach (Widget child in children)
		{
			child.destroy();
		}

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
				lab.size_request(out req);

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
		box.show_all();
		return str;
	}
	/* signal handler */
	private void tag_added (Stuffkeeper.DataBackend skdb_e, DataTag tag)
	{
		stdout.printf("Tag added\n");

		generate_cloud(skdb, win.vbox);
	}
	private void tag_removed (Stuffkeeper.DataBackend skdb_e,uint id)
	{
		stdout.printf("Tag removed\n");
		generate_cloud(skdb, win.vbox);
	}
	private void tag_changed (DataBackend skdb_e, DataTag tag)
	{
		stdout.printf("Tag changed\n");
		generate_cloud(skdb, win.vbox);
	}

	private void show_window(Stuffkeeper.DataBackend skdb_e)
	{
		/* if window is already open, do nothing */
		if(win != null)
		{
			win.present();
			return;
		}
		skdb = skdb_e;
		/* create dialog */
		win = new Dialog ();
		win.title = "Tag cloud";
		win.add_buttons(Gtk.Stock.CLOSE, ResponseType.CLOSE);




		win.response.connect(this.response_window);
		win.show();
		/* Generate the cloud */
		generate_cloud(skdb, win.vbox);
		skdb.tag_added.connect(tag_added);
		skdb.tag_removed.connect(tag_removed);
		skdb.tag_changed.connect(tag_changed);
	}

	private void response_window(Dialog dialog, int resonse_id)
	{
		win.destroy();

		stdout.printf("Close window\n");
		win = null;
		skdb.tag_added.disconnect(tag_added);
		skdb.tag_removed.disconnect(tag_removed);
		skdb.tag_changed.disconnect(tag_changed);
	}
}

//[ModuleInit]
public GLib.Type register_plugin(Module module)
{
    return typeof(Test);
}
