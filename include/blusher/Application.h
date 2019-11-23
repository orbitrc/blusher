#ifndef _BL_APPLICATION_H
#define _BL_APPLICATION_H

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

namespace bl {

class Application : public QGuiApplication
{
    Q_OBJECT
public:
    Application(int& argc, char *argv[]);

    ~Application()
    {}

    QQmlApplicationEngine* engine()
    {
        return &this->m_engine;
    }

private:
    QQmlApplicationEngine m_engine;

    void readConf(QVariantMap *env);
};

} // namespace bl

#endif // _BL_APPLICATION_H
