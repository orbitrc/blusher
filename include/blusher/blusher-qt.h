#ifndef _BLUSHER_QT_H
#define _BLUSHER_QT_H

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QCursor>

#ifndef BLUSHER_PATH
    #define BLUSHER_PATH "/usr/lib/blusher/qml"
#endif

namespace bl {

class Application : public QGuiApplication {
private:
    QQmlApplicationEngine engine;
public:
    /// \brief  Constructor
    /// \param  argc
    ///         Reference to C argc.
    /// \param  argv
    ///         C argv.
    Application(int& argc, char *argv[])
        : QGuiApplication(argc, argv), engine()
    {
        const QUrl url(QStringLiteral("qrc:/main.qml"));
        QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                         this, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);

        engine.addImportPath(BLUSHER_PATH);

        QVariantMap process;
        QVariantMap process_env;
        process_env.insert("BLUSHER_PATH", BLUSHER_PATH);
        process_env.insert("BLUSHER_PLATFORM", "Linux");
        process_env.insert("BLUSHER_DE_MODULE_PATH", "");
        process.insert("env", process_env);
        process.insert("app", QVariant::fromValue(this));

        engine.rootContext()->setContextProperty("Process", process);
        QObject::connect(
            this, &QObject::objectNameChanged,
            this, [this](const QString& objectName) { this->onObjectNameChanged(objectName); },
            Qt::QueuedConnection
        );

        engine.load(url);
    }

    /// \brief  Destructor
    ~Application()
    {}

    /// \brief  onObjectNameChanged slot.
    ///
    /// This is little hack for dynamic signal with small code.
    void onObjectNameChanged(const QString& objectName)
    {
        if (objectName == "BLUSHER_TEST") {
            this->quit();
        } else if (objectName == "BLUSHER_CURSOR_AUTO") {
            this->restoreOverrideCursor();
        } else if (objectName == "BLUSHER_CURSOR_WAIT") {
            this->setOverrideCursor(QCursor(Qt::WaitCursor));
        } else if (objectName == "BLUSHER_CURSOR_RESIZE_LEFT_RIGHT") {
            this->setOverrideCursor(QCursor(Qt::SplitHCursor));
        }
        this->setObjectName("");
    }
};

} // namespace bl

#endif // _BLUSHER_QT_H
