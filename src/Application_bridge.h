#ifndef _BLUSHER_APPLICATION_BRIDGE_H
#define _BLUSHER_APPLICATION_BRIDGE_H

#ifdef __cplusplus
extern "C" {
#endif

void* blusher_qt_init(int argc, char *argv[]);
int blusher_qt_exec(void *qml_app);
void blusher_qt_destroy(void *qml_app);

#ifdef __cplusplus
}
#endif

#endif /* _BLUSHER_APPLICATION_BRIDGE_H */
