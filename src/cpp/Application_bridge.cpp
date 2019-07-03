#include "../Application_bridge.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>

namespace bl {

class Application : public QGuiApplication {
public:
    QQmlApplicationEngine engine;

    Application(int argc, char *argv[])
        : QGuiApplication(argc, argv), engine()
    {
        const QUrl url(QStringLiteral("qrc:/main.qml"));
        QObject::connect(
            &(this->engine),
            &QQmlApplicationEngine::objectCreated,
            this,
            [url](QObject *obj, const QUrl &objUrl) {
                if (!obj && url == objUrl) {
                    QCoreApplication::exit(-1);
                }
            },
            Qt::QueuedConnection
        );

        this->engine.addImportPath("/usr/lib/blusher/qml");

        this->engine.load(url);
    }
};

} // namespace bl

extern "C" {

void* blusher_qt_init(int argc, char *argv[])
{
    bl::Application *app = new bl::Application(argc, argv);

    return (void*)app;
}

int blusher_qt_exec(void *self)
{
    return ((bl::Application*)self)->exec();
}

void blusher_qt_destroy(void *self)
{
    delete (bl::Application*)self;
}

} // extern "C"
