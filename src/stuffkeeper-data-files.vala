using GLib;
using Gtk;
using Stuffkeeper;

namespace Stuffkeeper{
    class Data.Files : Gtk.ScrolledWindow
    {
        private Gtk.IconView iv = new Gtk.IconView();
        private string field = null;
        private DataItem item = null; 
        private Gtk.ListStore store = new Gtk.ListStore(3,typeof(string), typeof(string), typeof(Gdk.Pixbuf));
        private const TargetEntry[] target_list = {
            {"text/uri-list", 0, 0}
        };
        private void item_changed(DataItem item, string changed_field)
        {
            if(changed_field == this.field)
            {
                update_files();

            }
        }
        private void update_add_file(string item)
        {
            var file = GLib.File.new_for_uri(item);
            var basename = file.get_basename();

            Gtk.TreeIter iter;
            this.store.append(out iter);
            Gdk.Pixbuf pix = null;
            /* Code to figure out the icon to display */
            try{
                var ic = file.query_info(GLib.FILE_ATTRIBUTE_STANDARD_ICON, GLib.FileQueryInfoFlags.NONE, null);
                GLib.Icon icon = (GLib.Icon ) ic.get_attribute_object(GLib.FILE_ATTRIBUTE_STANDARD_ICON);
                var it = Gtk.IconTheme.get_default();
                var icon_info = it.lookup_by_gicon(icon, 64, 0);
                pix = icon_info.load_icon();
            }catch (Error e){

            }

            if(pix == null ){
                pix = this.render_icon("gtk-file",Gtk.IconSize.DIALOG, null);
            }
            this.store.set(iter, 0, item, 1, basename, 2, pix);
        }
        private void update_files()
        {
            this.store.clear();
            string[] values = item.get_list(this.field );
            foreach(string item in values)
            {
                update_add_file(item);
            }
        }
        private void drag_data_recieved (Gdk.DragContext context, int x, int y, Gtk.SelectionData sel_data, uint info, uint time)
        {
            string[] uris = sel_data.get_uris();
            item.append_list(this.field, uris);
            Gtk.drag_finish(context,false, false, time);
        }
        private void delete_selected_items()
        {
            /* TODO leaks, wrong binding */
            List<string> items = null;
            weak List<Gtk.TreePath> list =this.iv.get_selected_items();
            foreach (Gtk.TreePath path in list)
            {
                Gtk.TreeIter iter;
                if(this.store.get_iter(out iter, path)){
                    string uri= null;
                    this.store.get(iter,0, out uri);
                    items.append(uri);
                }
            }
            foreach(string del in items) {
                item.remove_from_list(this.field, del);
            }
        }
        private void activate_selected_items()
        {
            /* TODO leaks, wrong binding */
            weak List<Gtk.TreePath> list =this.iv.get_selected_items();
            foreach (Gtk.TreePath path in list)
            {
                Gtk.TreeIter iter;
                if(this.store.get_iter(out iter, path)){
                    string uri= null;
                    this.store.get(iter,0, out uri);
                    try{
                        GLib.AppInfo.launch_default_for_uri(uri,null);
                    }catch(Error e){

                    }
                }
            }
        }

        private bool some_key_press_event (Gdk.EventKey event)
        {
            if((event.keyval == 65535)){
                delete_selected_items();
                return true;
            }
            return false;
        }
        public Files ( Stuffkeeper.DataItem item, string field)
        {
            this.field = field;
            this.item = item;


            update_files();


            this.item.item_changed.connect(item_changed);

            this.add(this.iv);
            this.shadow_type = Gtk.ShadowType.NONE;
            this.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.NEVER);
            this.iv.set_model(store);

            this.iv.set_pixbuf_column(2);
            this.iv.set_text_column(1);

            Gtk.drag_dest_set(this.iv,Gtk.DestDefaults.ALL,target_list,Gdk.DragAction.COPY|Gdk.DragAction.DEFAULT);
            this.iv.drag_data_received.connect(drag_data_recieved);

            this.iv.key_press_event.connect(some_key_press_event);

            this.iv.item_activated.connect((path) => {
                    Gtk.TreeIter iter;
                    if(this.store.get_iter(out iter,path)){
                    string uri= null;
                    this.store.get(iter, 0, out uri);
                    if(uri != null)
                    {
                        try{
                        GLib.AppInfo.launch_default_for_uri(uri,null);
                        }catch(Error e){

                        }
                    }
                }
            });

            this.iv.button_press_event.connect((event) => {
                if(event.button == 3) {

                    if(this.iv.get_selected_items() != null)
                    {
                        var menu = new Gtk.Menu();
                        var mitem = new Gtk.ImageMenuItem.from_stock("gtk-open",null);
                        mitem.activate.connect((item) => {
                            activate_selected_items();
                            });
                        menu.append(mitem);
                        mitem = new Gtk.ImageMenuItem.from_stock("gtk-delete",null);
                        mitem.activate.connect((item) => {
                            delete_selected_items();
                            });
                        menu.append(mitem);

                        menu.popup(null, null, null, event.button, event.time);
                        menu.show_all();
                    }
                    return true;
                }
                return false;
            });

        }
    }
}
