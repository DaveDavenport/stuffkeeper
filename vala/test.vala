using GLib;
using Gtk;
using Stuffkeeper;

public class Test : Stuffkeeper.Plugin {
		private Dialog win;

    public override PluginType get_plugin_type()
    {
        return PluginType.MENU|PluginType.ITEM;
    }

    public override weak string get_name()
    {
        return "Vala Test Plugin";
    }

    public override void run_menu(Stuffkeeper.DataBackend skdb)
    {
				this.show_window();
        weak List<DataItem> list = skdb.get_items();

        foreach (Stuffkeeper.DataItem item in list){
            stdout.printf("%s\n", item.get_title());
        }

    }

    public override void run_item (Stuffkeeper.DataItem item)
    {


    }


		/**
		 * Show window 
		 */

		private void show_window()
		{
			if(this.win != null)
					return;
			this.win = new Dialog ();
			win.response += this.response_window;
			win.show_all();
		}

		private void response_window(Dialog dialog, int resonse_id)
		{
			this.win.destroy();

			stdout.printf("Close window\n");
			this.win = null;
		}
}

[ModuleInit]
public GLib.Type register_plugin()
{
    return typeof(Test);
}
