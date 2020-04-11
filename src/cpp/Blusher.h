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
    enum class KeyModifier {
        None    = 0x00000000, // 00000000 00000000 00000000 00000000
        Shift   = 0x01000000, // 00000001 00000000 00000000 00000000
        Control = 0x02000000, // 00000010 00000000 00000000 00000000
        Alt     = 0x04000000, // 00000100 00000000 00000000 00000000
        Super   = 0x08000000, // 00001000 00000000 00000000 00000000
    };
    Q_ENUM(KeyModifier)

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
