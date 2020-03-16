#ifndef _BL_APPLICATION_H
#define _BL_APPLICATION_H

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <QDebug>

#ifndef BLUSHER_APP_NAME
#define BLUSHER_APP_NAME ""
#endif

#ifndef BLUSHER_APP_VERSION
#define BLUSHER_APP_VERSION ""
#endif

class QWidget;

namespace bl {

class Application : public QApplication
{
    Q_OBJECT

    Q_PROPERTY(int testValue READ testValue CONSTANT)
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

        QVariantMap process;
        QVariantMap env;

        this->readConf(&env);
        env.insert("BLUSHER_APP_NAME", BLUSHER_APP_NAME);
        env.insert("BLUSHER_APP_VERSION", BLUSHER_APP_VERSION);
#ifdef BLUSHER_DEBUG
        env.insert("BLUSHER_DEBUG", true);
#endif
        process.insert("env", env);
        process.insert("app", QVariant::fromValue(this));

        this->m_engine.rootContext()->setContextProperty("Process", process);

        // m_engine.addImportPath(BLUSHER_PATH);

//        this->m_popUpZone = new QWidget;

        Application::self = this;
    }

    ~Application()
    {}

    int exec();

    QQmlApplicationEngine* engine()
    {
        return &this->m_engine;
    }

    int testValue() const { return 42; }

    static Application *self;

    static Application* instance();

private:
    QQmlApplicationEngine m_engine;
    QWidget *m_popUpZone;

    void readConf(QVariantMap *env);
};

} // namespace bl

#endif // _BL_APPLICATION_H
