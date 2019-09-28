#ifndef _BLUSHER_QT_H
#define _BLUSHER_QT_H

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QCursor>
#include <QFile>

#include <unistd.h>

#ifndef BLUSHER_PATH
    #define BLUSHER_PATH "/usr/lib/blusher/qml"
#endif

namespace bl {

class Application : public QGuiApplication {
private:
    QQmlApplicationEngine engine;

    void read_conf(QVariantMap *env);

public:
    /// \brief  Constructor
    /// \param  argc
    ///         Reference to C argc.
    /// \param  argv
    ///         C argv.
    Application(int& argc, char *argv[]);

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

    QVariantMap make_process();

    QQmlApplicationEngine* get_engine();
};


Application::Application(int& argc, char *argv[])
    : QGuiApplication(argc, argv), engine()
{
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     this, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.addImportPath(BLUSHER_PATH);

#ifdef BLUSHER_DEBUG
    fprintf(stdout, "Blusher import path list: [\n");
    for (int i = 0; i < engine.importPathList().length(); ++i) {
        fprintf(stdout, "  \"%s\",\n", engine.importPathList()[i].toStdString().c_str());
    }
    fprintf(stdout, "]\n");
#endif

    QVariantMap process = this->make_process();
    process.insert("app", QVariant::fromValue(this));

    engine.rootContext()->setContextProperty("Process", process);
    QObject::connect(
        this, &QObject::objectNameChanged,
        this, [this](const QString& objectName) { this->onObjectNameChanged(objectName); },
        Qt::QueuedConnection
    );

    // engine.load(url);
}

void Application::read_conf(QVariantMap *env)
{
    QFile f("/etc/blusher.conf");
    if (!f.exists()) {
        env->insert("BLUSHER_DE_MODULE_PATH", "");
        return;
    }
    f.open(QFile::ReadOnly | QFile::Text);
    QString conf = QString(f.readAll());
    f.close();
    QStringList lines = conf.split("\n");
    for (int32_t i = 0; i < lines.length(); ++i) {
        // Ignore comment lines.
        if (lines[i].startsWith("#")) {
            continue;
        }
        QStringList key_value = lines[i].split("=");
        if (key_value[0] == "desktop_environment_path") {
            env->insert("BLUSHER_DE_MODULE_PATH", key_value[1]);
            engine.addImportPath(key_value[1]);
        }
    }
}


QVariantMap Application::make_process()
{
    QVariantMap process;
    QVariantMap process_env;
    this->read_conf(&process_env);
    process_env.insert("BLUSHER_PATH", BLUSHER_PATH);
    process_env.insert("BLUSHER_PLATFORM", "Linux");
    process_env.insert("BLUSHER_APP_NAME", BLUSHER_APP_NAME);
    process_env.insert("BLUSHER_APP_VERSION", BLUSHER_APP_VERSION);
#ifdef BLUSHER_DEBUG
    process_env.insert("BLUSHER_DEBUG", true);
#endif
    process.insert("env", process_env);

    return process;
}

QQmlApplicationEngine* Application::get_engine()
{
    return &this->engine;
}

} // namespace bl

#endif // _BLUSHER_QT_H
