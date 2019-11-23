#include <blusher.h>

#include <QDebug>

int main(int argc, char *argv[])
{
    bl::Application app(argc, argv);

    app.engine()->addImportPath("../lib/blusher/qml");
    qDebug() << qgetenv("QML2_IMPORT_PATH");
    qDebug() << app.engine()->importPathList();

    app.engine()->load(QUrl("qrc:/main.qml"));

    return app.exec();
}
