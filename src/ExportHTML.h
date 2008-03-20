#ifndef __EXPORT_HTML_H__
#define __EXPORT_HTML_H__

void export_item_to_html(StuffKeeperDataItem *item, const char *path, const char *filename);
void export_everything_to_html(StuffKeeperDataBackend *skdb, const char *directory);

#endif
