#ifndef _BL_APPLICATION_H
#define _BL_APPLICATION_H

// Application
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
// GUI
#include <QRectF>
// Debug
#include <QDebug>

#include <blusher/blusher_base.h>

#ifndef BLUSHER_APP_NAME
#define BLUSHER_APP_NAME ""
#endif

#ifndef BLUSHER_APP_VERSION
#define BLUSHER_APP_VERSION ""
#endif

class QWidget;

namespace bl {

class Menu;

class BL_EXPORT Application : public QApplication
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

    void openMenu(bl::Menu *menu, double x, double y);

    QRectF menuBarRect() const;
    Q_INVOKABLE void setMenuBarRect(QRectF rect);
    QRectF menuBarMenuItemRect() const;
    Q_INVOKABLE void setMenuBarMenuItemRect(QRectF rect);

signals:
    void menuClosed();
    void menuClosedByUser();

private:
    QQmlApplicationEngine m_engine;
    QWidget *m_popUpZone;   // Maybe not used.
    QRectF m_menuBarRect;
    QRectF m_menuBarMenuItemRect;

    void readConf(QVariantMap *env);
    void addPaths()
    {
#ifndef QT_DEBUG
        this->engine()->addImportPath("/usr/lib/blusher/qml");
        this->engine()->addPluginPath("/usr/lib");
#endif
    }
};


} // namespace bl

#endif // _BL_APPLICATION_H
