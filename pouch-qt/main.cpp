#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <iostream>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.addImportPath(BLUSHER_PATH);

    //////
    /*
    auto l = engine.importPathList();
    std::cout << l.length() << std::endl;
    for (auto i = 0; i < l.length(); ++i) {
        std::cout << l[i].toStdString() << std::endl;
    }
    std::cout << "--path--" << std::endl;
    std::cout << BLUSHER_PATH << std::endl;
    */
    //////

    engine.load(url);

    return app.exec();
}
