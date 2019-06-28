#ifndef _BLUSHER_APPLICATION_BRIDGE_H
#define _BLUSHER_APPLICATION_BRIDGE_H

#ifdef __cplusplus
extern "C" {
#endif

void* blusher_qt_init();
void blusher_qt_destroy(void *instance);

#ifdef __cplusplus
}
#endif

#endif /* _BLUSHER_APPLICATION_BRIDGE_H */
