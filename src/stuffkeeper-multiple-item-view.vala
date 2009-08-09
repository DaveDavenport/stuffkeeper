using GLib;
using Gtk;
using Stuffkeeper;

public class Stuffkeeper.MultipleItemView : Gtk.VBox
{
    private List <weak Stuffkeeper.DataItem> items = null;
    private Gtk.EventBox sw_event = null;
    private Gtk.EventBox header =null;
    private weak Stuffkeeper.DataBackend backend = null;

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
                Gdk.Color color =source.style.light[Gtk.StateType.NORMAL];
                this.sw_event.modify_bg(Gtk.StateType.NORMAL, color);
        });

        var sw_vbox = new Gtk.VBox(false, 6);
        sw_vbox.border_width = 8;
        sw.add_with_viewport(sw_event);
        sw_event.add(sw_vbox);


        this.pack_start(sw, true, true, 0);

        /* Setup the view */
        var title_labels = new Gtk.Label("");
        title_labels.set_markup(GLib.Markup.printf_escaped("<b>%s</b>", "Items:"));
        title_labels.set_alignment(0.0f, 0.5f);
        sw_vbox.pack_start(title_labels, false, false, 0);
        foreach(DataItem item in this.items) {
            var hbox = new Gtk.HBox(false, 6);
            var arrow = new Gtk.Arrow(Gtk.ArrowType.RIGHT, Gtk.ShadowType.NONE);
            hbox.pack_start(arrow, false, false,0);
            var title = new Stuffkeeper.DataEntry(item, null);
            hbox.pack_start(title, true, true, 0);
            sw_vbox.pack_start(hbox, false, false, 0);
        }

        /* Tag Setup */
        var tag_label = new Gtk.Label("");
        tag_label.set_markup(GLib.Markup.printf_escaped("<b>%s</b>", "Tags:"));
        tag_label.set_alignment(0.0f, 0.5f);
        sw_vbox.pack_start(tag_label, false, false, 0);

        foreach ( DataTag tag in this.backend.get_tags())
        {
            var tlabel = new Stuffkeeper.DataLabel.tag(tag);
            tlabel.set_alignment(0.0f, 0.5f);
            sw_vbox.pack_start(tlabel, false, false, 0);
        }

        this.show_all();
    }

}
