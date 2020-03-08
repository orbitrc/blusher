#ifndef _BL_APPLICATION_H
#define _BL_APPLICATION_H

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <QDebug>

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
    Application(int& argc, char *argv[]);

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

    void readConf(QVariantMap *env);
};

} // namespace bl

#endif // _BL_APPLICATION_H
