#include "Menu.h"

#include <QDebug>

#include <blusher/Application.h>

namespace bl {

Menu::Menu(QObject *parent)
    : QObject(parent)
{
}

int Menu::type() const
{
    return this->m_type;
}

void Menu::setType(int type)
{
    if (this->m_type != type) {
        this->m_type = type;

        emit this->typeChanged();
    }
}

QString Menu::title() const
{
    return this->m_title;
}

void Menu::setTitle(QString title)
{
    if (this->m_title != title) {
        this->m_title = title;

        emit this->titleChanged();
    }
}

QQmlListProperty<QObject> Menu::items()
{
    return QQmlListProperty<QObject>(this, this->m_items);
}

void Menu::addItem(QObject *item)
{
    this->m_items.append(item);
}

void Menu::open()
{
    Application::instance()->openMenu(this);
}

} // namespace bl
