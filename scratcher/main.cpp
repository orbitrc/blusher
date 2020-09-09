#include <blusher/blusher.h>

#include <QDebug>

int main(int argc, char *argv[])
{
    bl::Application app(argc, argv);

#ifdef BL_PLATFORM_MACOS
    app.engine()->addImportPath("../../../../lib/blusher/qml");
#else
    app.engine()->addImportPath("../lib/blusher/qml");
#endif
    qDebug() << qgetenv("QML2_IMPORT_PATH");
    qDebug() << app.engine()->importPathList();

    app.engine()->load(QUrl("qrc:/main.qml"));

    return app.exec();
}
