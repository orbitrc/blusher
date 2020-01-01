#ifndef _BL_APPLICATION_H
#define _BL_APPLICATION_H

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <QDebug>

namespace bl {

class Application : public QGuiApplication
{
    Q_OBJECT

    Q_PROPERTY(int testValue READ testValue CONSTANT)
public:
    Application(int& argc, char *argv[]);

    ~Application()
    {}

    QQmlApplicationEngine* engine()
    {
        return &this->m_engine;
    }

    int testValue() const { return 42; }

    static Application *self;

    static Application* instance();

private:
    QQmlApplicationEngine m_engine;

    void readConf(QVariantMap *env);
};

} // namespace bl

#endif // _BL_APPLICATION_H
