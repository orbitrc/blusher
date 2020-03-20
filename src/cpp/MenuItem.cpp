#include "MenuItem.h"

namespace bl {

MenuItem::MenuItem(QObject *parent)
    : QObject(parent)
{

}

QString MenuItem::title() const
{
    return this->m_title;
}

void MenuItem::setTitle(QString title)
{
    if (this->m_title != title) {
        this->m_title = title;

        emit this->titleChanged();
    }
}

} // namespace bl
