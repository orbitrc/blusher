#ifndef _BL_BLUSHER_H
#define _BL_BLUSHER_H

#include <QObject>

#include <blusher/Application.h>

namespace bl {

class Blusher : public QObject
{
    Q_OBJECT

    Q_PROPERTY(Application* app READ app NOTIFY appChanged)
public:
    explicit Blusher(QObject *parent = nullptr);

    Application* app() const;
    void _set_app(QObject *app);

    static Blusher *singleton;

signals:
    void appChanged();

public slots:

private:
    QObject *p_app;
};

#endif // _BL_BLUSHER_H

} // namespace bl
