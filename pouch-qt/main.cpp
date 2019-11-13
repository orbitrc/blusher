#include <blusher/blusher-qt.h>

int main(int argc, char *argv[])
{
    bl::Application app(argc, argv);

    app.get_engine()->load(QUrl("qrc:/main.qml"));

    return app.exec();
}
