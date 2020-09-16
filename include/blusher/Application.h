#ifndef _BL_APPLICATION_H
#define _BL_APPLICATION_H

// Application
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
// Core
#include <QFile>
// GUI
#include <QRectF>
// Debug
#include <QDebug>

#include <blusher/base.h>

#ifndef BLUSHER_APP_NAME
#define BLUSHER_APP_NAME ""
#endif

#ifndef BLUSHER_APP_VERSION
#define BLUSHER_APP_VERSION ""
#endif

#ifndef BLUSHER_PATH
#define BLUSHER_PATH "/usr/lib/blusher"
#endif

class QWidget;

namespace bl {

class Menu;

class Application : public QApplication
{
public:
    /// \brief  Constructor
    /// \param  argc
    ///         Reference to C argc.
    /// \param  argv
    ///         C argv.
    Application(int& argc, char *argv[])
        : QApplication(argc, argv)
    {
        const QUrl url(QStringLiteral("qrc:/main.qml"));
        QObject::connect(&m_engine, &QQmlApplicationEngine::objectCreated,
                         this, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);

        this->addPaths();

        QVariantMap process;
        QVariantMap env;

        this->readConf(&env);
        // Add DE module path.
        if (env.value("BLUSHER_DE_MODULE_PATH").toString() == "") {
            qDebug() << "bl::Application - DE module path is empty. using standalone.\n";
            this->m_engine.addImportPath(QString(BLUSHER_PATH) + "/qml/Blusher/Standalone");
        } else {
            this->m_engine.addImportPath(env.value("BLUSHER_DE_MODULE_PATH").toString());
        }
        env.insert("BLUSHER_APP_NAME", BLUSHER_APP_NAME);
        env.insert("BLUSHER_APP_VERSION", BLUSHER_APP_VERSION);
#ifdef BLUSHER_DEBUG
        env.insert("BLUSHER_DEBUG", true);
#endif
        process.insert("env", env);
        process.insert("app", QVariant::fromValue(this));

        this->m_engine.rootContext()->setContextProperty("Process", process);
    }

    ~Application()
    {}

    int exec();

    QQmlApplicationEngine* engine()
    {
        return &this->m_engine;
    }

signals:
    void menuClosed();
    void menuClosedByUser();

private:
    QQmlApplicationEngine m_engine;
    QWidget *m_popUpZone;   // Maybe not used.

    void readConf(QVariantMap *env);
    void addPaths()
    {
        QString blusherPath = QString(BLUSHER_PATH) + "/qml";
        this->engine()->addImportPath(blusherPath);
    }
};


inline void Application::readConf(QVariantMap *env)
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
    // Parse file.
    for (int32_t i = 0; i < lines.length(); ++i) {
        // Ignore comment lines.
        if (lines[i].startsWith("#")) {
            continue;
        }
        QStringList key_value = lines[i].split("=");
        // Desktop environment module path.
        if (key_value[0] == "desktop_environment_path") {
            env->insert("BLUSHER_DE_MODULE_PATH", key_value[1]);
            this->m_engine.addImportPath(key_value[1]);
        }
    }
}

inline int Application::exec()
{
    return QApplication::exec();
}

} // namespace bl

#endif // _BL_APPLICATION_H
