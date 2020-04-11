#ifndef _BL_KEY_EVENT_H
#define _BL_KEY_EVENT_H

#include <QObject>

namespace bl {

class KeyEvent : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int modifiers READ modifiers CONSTANT)
    Q_PROPERTY(int key READ key CONSTANT)
public:
    explicit KeyEvent(int modifiers, int key, QObject *parent = nullptr);

    int modifiers() const;
    int key() const;

signals:

private:
    int m_modifiers;
    int m_key;
};

} // namespace bl

#endif // _BL_KEY_EVENT_H
