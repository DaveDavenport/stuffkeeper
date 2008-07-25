
#include "stuffkeeper-data-boolean-config.h"
#include <stdio.h>




struct _StuffkeeperDataBooleanConfigPrivate {
	char* field;
	StuffkeeperDataSchema* schema;
	GtkCheckButton* checkbox;
};

#define STUFFKEEPER_DATA_BOOLEAN_CONFIG_GET_PRIVATE(o) (G_TYPE_INSTANCE_GET_PRIVATE ((o), STUFFKEEPER_TYPE_DATA_BOOLEAN_CONFIG, StuffkeeperDataBooleanConfigPrivate))
enum  {
	STUFFKEEPER_DATA_BOOLEAN_CONFIG_DUMMY_PROPERTY
};
static gboolean stuffkeeper_data_boolean_config_quit;
static void _stuffkeeper_data_boolean_config_field_changed_stuffkeeper_data_schema_schema_custom_field_changed (StuffkeeperDataSchema* _sender, const char* id, gint field, gpointer self);
static void stuffkeeper_data_boolean_config_field_changed (StuffkeeperDataBooleanConfig* self, StuffkeeperDataSchema* schema, const char* id, gint field);
static void stuffkeeper_data_boolean_config_toggled (StuffkeeperDataBooleanConfig* self, GtkToggleButton* toggle);
static void _stuffkeeper_data_boolean_config_toggled_gtk_toggle_button_toggled (GtkCheckButton* _sender, gpointer self);
static GObject * stuffkeeper_data_boolean_config_constructor (GType type, guint n_construct_properties, GObjectConstructParam * construct_properties);
static gpointer stuffkeeper_data_boolean_config_parent_class = NULL;
static void stuffkeeper_data_boolean_config_dispose (GObject * obj);



static void _stuffkeeper_data_boolean_config_field_changed_stuffkeeper_data_schema_schema_custom_field_changed (StuffkeeperDataSchema* _sender, const char* id, gint field, gpointer self) {
	stuffkeeper_data_boolean_config_field_changed (self, _sender, id, field);
}


/**
 * Listen to changes to this field
 */
static void stuffkeeper_data_boolean_config_field_changed (StuffkeeperDataBooleanConfig* self, StuffkeeperDataSchema* schema, const char* id, gint field) {
	g_return_if_fail (STUFFKEEPER_IS_DATA_BOOLEAN_CONFIG (self));
	g_return_if_fail (STUFFKEEPER_IS_DATA_SCHEMA (schema));
	g_return_if_fail (id != NULL);
	if (field == 0) {
		gint value;
		value = 0;
		if (stuffkeeper_data_schema_get_custom_field_integer (schema, id, 0, &value)) {
			if (gtk_toggle_button_get_active (GTK_TOGGLE_BUTTON (self->priv->checkbox)) != ((gboolean) (value))) {
				guint _tmp0;
				g_signal_handlers_disconnect_matched (schema, G_SIGNAL_MATCH_ID | G_SIGNAL_MATCH_FUNC | G_SIGNAL_MATCH_DATA, (g_signal_parse_name ("schema-custom-field-changed", STUFFKEEPER_TYPE_DATA_SCHEMA, &_tmp0, NULL, FALSE), _tmp0), 0, NULL, ((GCallback) (_stuffkeeper_data_boolean_config_field_changed_stuffkeeper_data_schema_schema_custom_field_changed)), self);
				gtk_toggle_button_set_active (GTK_TOGGLE_BUTTON (self->priv->checkbox), ((gboolean) (value)));
				g_signal_connect_object (schema, "schema-custom-field-changed", ((GCallback) (_stuffkeeper_data_boolean_config_field_changed_stuffkeeper_data_schema_schema_custom_field_changed)), self, 0);
			}
		}
	}
}


/**
 * Listen to clicks
 */
static void stuffkeeper_data_boolean_config_toggled (StuffkeeperDataBooleanConfig* self, GtkToggleButton* toggle) {
	g_return_if_fail (STUFFKEEPER_IS_DATA_BOOLEAN_CONFIG (self));
	g_return_if_fail (GTK_IS_TOGGLE_BUTTON (toggle));
	if (gtk_toggle_button_get_active (toggle)) {
		stuffkeeper_data_schema_set_custom_field_integer (self->priv->schema, self->priv->field, 0, 1);
	} else {
		stuffkeeper_data_schema_set_custom_field_integer (self->priv->schema, self->priv->field, 0, 0);
	}
}


static void _stuffkeeper_data_boolean_config_toggled_gtk_toggle_button_toggled (GtkCheckButton* _sender, gpointer self) {
	stuffkeeper_data_boolean_config_toggled (self, _sender);
}


/**
 * Set it up 
 */
void stuffkeeper_data_boolean_config_setup (StuffkeeperDataBooleanConfig* self, StuffkeeperDataSchema* schema, const char* fid) {
	gint value;
	StuffkeeperDataSchema* _tmp1;
	StuffkeeperDataSchema* _tmp0;
	char* _tmp3;
	const char* _tmp2;
	g_return_if_fail (STUFFKEEPER_IS_DATA_BOOLEAN_CONFIG (self));
	g_return_if_fail (STUFFKEEPER_IS_DATA_SCHEMA (schema));
	g_return_if_fail (fid != NULL);
	value = 0;
	_tmp1 = NULL;
	_tmp0 = NULL;
	self->priv->schema = (_tmp1 = (_tmp0 = schema, (_tmp0 == NULL ? NULL : g_object_ref (_tmp0))), (self->priv->schema == NULL ? NULL : (self->priv->schema = (g_object_unref (self->priv->schema), NULL))), _tmp1);
	_tmp3 = NULL;
	_tmp2 = NULL;
	self->priv->field = (_tmp3 = (_tmp2 = fid, (_tmp2 == NULL ? NULL : g_strdup (_tmp2))), (self->priv->field = (g_free (self->priv->field), NULL)), _tmp3);
	if (stuffkeeper_data_schema_get_custom_field_integer (schema, self->priv->field, 0, &value)) {
		gtk_toggle_button_set_active (GTK_TOGGLE_BUTTON (self->priv->checkbox), ((gboolean) (value)));
	}
	/* connect signals */
	g_signal_connect_object (GTK_TOGGLE_BUTTON (self->priv->checkbox), "toggled", ((GCallback) (_stuffkeeper_data_boolean_config_toggled_gtk_toggle_button_toggled)), self, 0);
	g_signal_connect_object (schema, "schema-custom-field-changed", ((GCallback) (_stuffkeeper_data_boolean_config_field_changed_stuffkeeper_data_schema_schema_custom_field_changed)), self, 0);
}


StuffkeeperDataBooleanConfig* stuffkeeper_data_boolean_config_new (void) {
	StuffkeeperDataBooleanConfig * self;
	self = g_object_newv (STUFFKEEPER_TYPE_DATA_BOOLEAN_CONFIG, 0, NULL);
	return self;
}


/**
 * Construct 
 */
static GObject * stuffkeeper_data_boolean_config_constructor (GType type, guint n_construct_properties, GObjectConstructParam * construct_properties) {
	GObject * obj;
	StuffkeeperDataBooleanConfigClass * klass;
	GObjectClass * parent_class;
	StuffkeeperDataBooleanConfig * self;
	klass = STUFFKEEPER_DATA_BOOLEAN_CONFIG_CLASS (g_type_class_peek (STUFFKEEPER_TYPE_DATA_BOOLEAN_CONFIG));
	parent_class = G_OBJECT_CLASS (g_type_class_peek_parent (klass));
	obj = parent_class->constructor (type, n_construct_properties, construct_properties);
	self = STUFFKEEPER_DATA_BOOLEAN_CONFIG (obj);
	{
		GtkLabel* label;
		GtkCheckButton* _tmp0;
		label = g_object_ref_sink (gtk_label_new ("Default value"));
		_tmp0 = NULL;
		self->priv->checkbox = (_tmp0 = g_object_ref_sink (gtk_check_button_new ()), (self->priv->checkbox == NULL ? NULL : (self->priv->checkbox = (g_object_unref (self->priv->checkbox), NULL))), _tmp0);
		gtk_box_pack_start (GTK_BOX (self), GTK_WIDGET (label), FALSE, FALSE, ((guint) (0)));
		gtk_box_pack_start (GTK_BOX (self), GTK_WIDGET (self->priv->checkbox), TRUE, TRUE, ((guint) (0)));
		gtk_widget_show_all (GTK_WIDGET (self));
		(label == NULL ? NULL : (label = (g_object_unref (label), NULL)));
	}
	return obj;
}


static void stuffkeeper_data_boolean_config_class_init (StuffkeeperDataBooleanConfigClass * klass) {
	stuffkeeper_data_boolean_config_parent_class = g_type_class_peek_parent (klass);
	g_type_class_add_private (klass, sizeof (StuffkeeperDataBooleanConfigPrivate));
	G_OBJECT_CLASS (klass)->constructor = stuffkeeper_data_boolean_config_constructor;
	G_OBJECT_CLASS (klass)->dispose = stuffkeeper_data_boolean_config_dispose;
	stuffkeeper_data_boolean_config_quit = ((gboolean) (0));
}


static void stuffkeeper_data_boolean_config_instance_init (StuffkeeperDataBooleanConfig * self) {
	self->priv = STUFFKEEPER_DATA_BOOLEAN_CONFIG_GET_PRIVATE (self);
	self->priv->field = NULL;
	self->priv->schema = NULL;
	self->priv->checkbox = NULL;
}


static void stuffkeeper_data_boolean_config_dispose (GObject * obj) {
	StuffkeeperDataBooleanConfig * self;
	self = STUFFKEEPER_DATA_BOOLEAN_CONFIG (obj);
	{
		fprintf (stdout, "Dispose\n");
		/* This gets called twice.. */
		if (!stuffkeeper_data_boolean_config_quit) {
			guint _tmp1;
			g_signal_handlers_disconnect_matched (self->priv->schema, G_SIGNAL_MATCH_ID | G_SIGNAL_MATCH_FUNC | G_SIGNAL_MATCH_DATA, (g_signal_parse_name ("schema-custom-field-changed", STUFFKEEPER_TYPE_DATA_SCHEMA, &_tmp1, NULL, FALSE), _tmp1), 0, NULL, ((GCallback) (_stuffkeeper_data_boolean_config_field_changed_stuffkeeper_data_schema_schema_custom_field_changed)), self);
		}
		stuffkeeper_data_boolean_config_quit = TRUE;
	}
	self->priv->field = (g_free (self->priv->field), NULL);
	(self->priv->schema == NULL ? NULL : (self->priv->schema = (g_object_unref (self->priv->schema), NULL)));
	(self->priv->checkbox == NULL ? NULL : (self->priv->checkbox = (g_object_unref (self->priv->checkbox), NULL)));
	G_OBJECT_CLASS (stuffkeeper_data_boolean_config_parent_class)->dispose (obj);
}


GType stuffkeeper_data_boolean_config_get_type (void) {
	static GType stuffkeeper_data_boolean_config_type_id = 0;
	if (G_UNLIKELY (stuffkeeper_data_boolean_config_type_id == 0)) {
		static const GTypeInfo g_define_type_info = { sizeof (StuffkeeperDataBooleanConfigClass), (GBaseInitFunc) NULL, (GBaseFinalizeFunc) NULL, (GClassInitFunc) stuffkeeper_data_boolean_config_class_init, (GClassFinalizeFunc) NULL, NULL, sizeof (StuffkeeperDataBooleanConfig), 0, (GInstanceInitFunc) stuffkeeper_data_boolean_config_instance_init };
		stuffkeeper_data_boolean_config_type_id = g_type_register_static (GTK_TYPE_HBOX, "StuffkeeperDataBooleanConfig", &g_define_type_info, 0);
	}
	return stuffkeeper_data_boolean_config_type_id;
}




