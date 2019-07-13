#include <blusher/Application.h>
#include "Application_bridge.h"

#include <stdlib.h>

const type __type__bl_Application = {
    .name = "bl::Application",
    .size = -1
};

typedef struct bl_Application_impl {
    void *_qml_app;
} bl_Application_impl;

bl_Application bl_Application_constructor(const list_string *argv)
{
    bl_Application self;

    self.pImpl = (void*)malloc(sizeof(struct bl_Application_impl));
    ((bl_Application_impl*)(self.pImpl))->_qml_app = blusher_qt_init(
        list_1__get__count(argv).num,
        argv);

    self.rc = 1;

    return self;
}

integer bl_Application_exec(const bl_Application *self)
{
    bl_Application_impl *pImpl = (bl_Application_impl*)(self->pImpl);
    integer ret = (integer){ blusher_qt_exec(pImpl->_qml_app) };

    blusher_qt_destroy(pImpl->_qml_app);

    return ret;
}
