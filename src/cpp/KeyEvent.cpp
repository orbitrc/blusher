#include "KeyEvent.h"

namespace bl {

KeyEvent::KeyEvent(int modifiers, int key, QObject *parent)
    : QObject(parent)
{
    this->m_modifiers = modifiers;
    this->m_key = key;
}

int KeyEvent::modifiers() const
{
    return this->m_modifiers;
}

int KeyEvent::key() const
{
    return this->m_key;
}

} // namespace bl
