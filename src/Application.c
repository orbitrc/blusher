#include <blusher/Application.h>
#include "Application_bridge.h"

const type __type__bl_Application {
    .name = "bl::Application",
    .size = -1
};

struct bl_Application_impl {
    void *_qml_app;
};

bl_Application bl_Application_constructor(const list_string *argv)
{
    bl_Application self;

    self.pImpl = new bl_Application_impl;
    self.pImpl->_qml_app = blusher_qt_init(argc, argv);

    self.rc = 1;

    return self;
}

integer bl_Application_exec(bl_Application *self)
{
    integer ret = (integer){ blusher_qt_exec(self->_qml_app) };

    blusher_qt_destroy(self->_qml_app);

    return ret;
}
