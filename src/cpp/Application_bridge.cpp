#include "../Application_bridge.h"

extern "C" {

struct _ptrs {
    QGuiApplication *app;
    QQmlApplicationEngine *engine;
};

void* blusher_qt_init()
{
    struct _ptrs *self = new struct _ptrs;
    self->app = new QGuiApplication(argc, argv);

    self->engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(
        self->engine,
        &QQmlApplicationEngine::objectCreated,
        self->app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl) {
                QCoreApplication::exit(-1);
            }
        },
        Qt::QueuedConnection
    );

    self->engine.addImportPath("/usr/lib/blusher/qml");

    self->engine.load(url);

    return (void*)self;
}

void blusher_qt_destroy(void *self)
{
    delete self->engine;
    delete self->app;
    delete self;
}
