
#ifndef __STUFFKEEPER_DATA_BOOLEAN_CONFIG_H__
#define __STUFFKEEPER_DATA_BOOLEAN_CONFIG_H__

#include <glib.h>
#include <glib-object.h>
#include <gtk/gtk.h>
#include <stuffkeeper-plugin.h>
#include <stdlib.h>
#include <string.h>

G_BEGIN_DECLS


#define STUFFKEEPER_TYPE_DATA_BOOLEAN_CONFIG (stuffkeeper_data_boolean_config_get_type ())
#define STUFFKEEPER_DATA_BOOLEAN_CONFIG(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), STUFFKEEPER_TYPE_DATA_BOOLEAN_CONFIG, StuffkeeperDataBooleanConfig))
#define STUFFKEEPER_DATA_BOOLEAN_CONFIG_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), STUFFKEEPER_TYPE_DATA_BOOLEAN_CONFIG, StuffkeeperDataBooleanConfigClass))
#define STUFFKEEPER_IS_DATA_BOOLEAN_CONFIG(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), STUFFKEEPER_TYPE_DATA_BOOLEAN_CONFIG))
#define STUFFKEEPER_IS_DATA_BOOLEAN_CONFIG_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), STUFFKEEPER_TYPE_DATA_BOOLEAN_CONFIG))
#define STUFFKEEPER_DATA_BOOLEAN_CONFIG_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), STUFFKEEPER_TYPE_DATA_BOOLEAN_CONFIG, StuffkeeperDataBooleanConfigClass))

typedef struct _StuffkeeperDataBooleanConfig StuffkeeperDataBooleanConfig;
typedef struct _StuffkeeperDataBooleanConfigClass StuffkeeperDataBooleanConfigClass;
typedef struct _StuffkeeperDataBooleanConfigPrivate StuffkeeperDataBooleanConfigPrivate;

struct _StuffkeeperDataBooleanConfig {
	GtkHBox parent_instance;
	StuffkeeperDataBooleanConfigPrivate * priv;
};

struct _StuffkeeperDataBooleanConfigClass {
	GtkHBoxClass parent_class;
};


void stuffkeeper_data_boolean_config_setup (StuffkeeperDataBooleanConfig* self, StuffkeeperDataSchema* schema, const char* fid);
StuffkeeperDataBooleanConfig* stuffkeeper_data_boolean_config_new (void);
GType stuffkeeper_data_boolean_config_get_type (void);


G_END_DECLS

#endif
