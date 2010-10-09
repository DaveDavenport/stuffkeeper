using GLib;
using Gtk;
using Stuffkeeper;

public class MultipleItemTag : Gtk.CheckButton
{
    private weak Stuffkeeper.DataBackend backend = null;
    private weak List <weak Stuffkeeper.DataItem> items = null;
    private DataTag tag = null;
    private bool updating = false;

    private void update_check_state()
    {
        int check = 0;
        foreach (DataItem item in this.items) {
           if(item.has_tag(tag)) check++;
        }

        this.set_active(false);
        this.set_inconsistent(false);

        if(check == this.items.length()) this.set_active(true);
        else if (check > 0) this.set_inconsistent(true);

    }
    /* The following callbacks where lambda's but because of vala bug, it are actual callbacks now */
    private void toggled_callback()
    {
        if(this.updating) return;
        if(this.active) {
            foreach(DataItem item in this.items) {
                if(item.has_tag(this.tag) == false)
                    item.add_tag(this.tag);
            }
        }else{
            foreach(DataItem item in this.items) {
                if(item.has_tag(this.tag) == true)
                    item.remove_tag(this.tag);
            }
        }
    }
    private void item_tags_changed_callback(DataItem item)
    {
        if(this.updating) return;
        this.updating = true;
        update_check_state();
        this.updating = false;
    }
    private void database_locked(ParamSpec arg1)
    {
        this.set_sensitive(!this.backend.get_locked());
    }
    public MultipleItemTag (DataTag tag, List<weak Stuffkeeper.DataItem> items)
    {
        this.items = items;
        this.backend = this.items.data.get_backend();
        this.tag = tag;
        this.update_check_state();
        foreach (DataItem item in this.items) {
            item.item_tags_changed.connect(item_tags_changed_callback);
        }

        this.backend.notify["locked"].connect(database_locked);

        this.set_sensitive(!this.backend.get_locked());
        this.toggled.connect(toggled_callback);
    }


}
public class Stuffkeeper.MultipleItemView : Gtk.VBox
{
    private List <weak Stuffkeeper.DataItem> items = null;
    private Gtk.EventBox sw_event = null;
    private Gtk.EventBox header =null;
    private weak Stuffkeeper.DataBackend backend = null;
    private Gtk.VBox sw_vbox = null;
    private Gtk.Table tag_vbox = null;

    public MultipleItemView (List<weak Stuffkeeper.DataItem> items)
    {
        /* Copy the list */
        this.items = items.copy();
        this.backend = this.items.data.get_backend();
        /* Title box */
        header = new Gtk.EventBox();
        /* Color the header */
        this.style_set.connect((source, style) => {
            var color = source.style.bg[Gtk.StateType.SELECTED];
            this.header.modify_bg(Gtk.StateType.NORMAL, color);
            color = source.style.fg[Gtk.StateType.SELECTED];
            this.header.get_child().modify_fg(Gtk.StateType.NORMAL, color);
            color = source.style.text[Gtk.StateType.SELECTED];
            this.header.get_child().modify_text(Gtk.StateType.NORMAL, color);
        });

        var header_label = new Gtk.Label("");
        header_label.set_markup(GLib.Markup.printf_escaped("<span size='x-large' weight='bold'>%u %s</span>", this.items.length(), "Selected items"));
        header_label.set_alignment(0.0f, 0.5f);
        header_label.set_padding(8,8);
        header.add(header_label);
        this.pack_start(header, false, false, 0);

        /* The view below */
        var sw = new Gtk.ScrolledWindow(null, null);
        sw.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
        /* Color background */
        sw_event = new Gtk.EventBox();
        this.style_set.connect((source, style) => {
                Gdk.Color color =source.style.white;//light[Gtk.StateType.NORMAL];
                this.sw_event.modify_bg(Gtk.StateType.NORMAL, color);
        });

        sw_vbox = new Gtk.VBox(false, 6);
        sw_vbox.border_width = 8;
        sw.add_with_viewport(sw_event);
        sw_event.add(sw_vbox);


        this.pack_start(sw, true, true, 0);

        /* Setup the view */
        var title_labels = new Gtk.Label("");
        title_labels.set_markup(GLib.Markup.printf_escaped("<b>%s</b>", "Items:"));
        title_labels.set_alignment(0.0f, 0.5f);
        title_labels.modify_fg(Gtk.StateType.NORMAL, this.style.black);
        sw_vbox.pack_start(title_labels, false, false, 0);
        foreach(DataItem item in this.items) {
            var hbox = new Gtk.HBox(false, 6);
	    var button = new Gtk.Button();
	    var arrow = new Gtk.Image.from_pixbuf(item.get_schema().get_pixbuf());
	    button.relief = Gtk.ReliefStyle.NONE;
	    this.style_set.connect((source, style) => {
			    Gdk.Color color =source.style.white;//light[Gtk.StateType.NORMAL];
			    button.modify_bg(Gtk.StateType.NORMAL, color);
			    });
            /** TODO image needs updating when schema changed it icon! */
            hbox.pack_start(arrow, false, false,0);
            var title = new Stuffkeeper.DataEntry(item, null);
            hbox.pack_start(title, true, true, 0);
	    button.add(hbox);
            sw_vbox.pack_start(button, false, false, 0);
	    button.set_data<weak DataItem>("item", item);
	    button.clicked.connect((source) => {
			DataItem fitem = button.get_data<weak DataItem>("item");
			Gtk.Window win = new Stuffkeeper.ItemWindow(fitem.get_backend(), fitem, Stuffkeeper.config_file);
		});
        }

        /* Tag Setup */
        var tag_label = new Gtk.Label("");
        tag_label.set_markup(GLib.Markup.printf_escaped("<b>%s</b>", "Tags:"));
        tag_label.set_alignment(0.0f, 0.5f);
        tag_label.modify_fg(Gtk.StateType.NORMAL, this.style.black);
        sw_vbox.pack_start(tag_label, false, false, 0);

        tag_vbox = new Gtk.Table(0,0,false);
        sw_vbox.pack_start(tag_vbox, false, false, 0);

        reload_tags(0);

        this.backend.tag_added.connect(tag_added);
        this.backend.tag_removed.connect(reload_tags);

        this.show_all();
    }
    private void tag_added(DataTag tag)
    {
        reload_tags(0);
    }
    static int compare_func(DataTag tag1, DataTag tag2)
    {
        return tag1.get_title().collate(tag2.get_title());
    }
    private void reload_tags(uint id)
    {
        int column=3;
        int items = 0;
        var list = tag_vbox.get_children();
        foreach(Gtk.Widget child in list) {
            child.destroy();
        }
        var taglist = this.backend.get_tags();
        taglist.sort((GLib.CompareFunc)compare_func);
        foreach ( DataTag tag in taglist)
        {
            var hbox = new Gtk.HBox (false, 6);
            var chk = new MultipleItemTag(tag, this.items);
            hbox.pack_start(chk, false, false, 0);

            var tlabel = new Stuffkeeper.DataLabel.tag(tag);
            tlabel.modify_fg(Gtk.StateType.NORMAL, this.style.black);
            tlabel.set_alignment(0.0f, 0.5f);
            hbox.pack_start(tlabel, true, true, 0);
            this.tag_vbox.attach(hbox, items%column, items%column+1, items/column, items/column+1,
                    Gtk.AttachOptions.EXPAND|Gtk.AttachOptions.FILL, Gtk.AttachOptions.EXPAND|Gtk.AttachOptions.FILL,0,0);
            items++;
        }
        tag_vbox.show_all();
    }
}
