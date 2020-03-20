#include "Menu.h"

#include <QMenu>

#include <QDebug>

#include <blusher/Application.h>
#include "MenuItem.h"

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

QList<QObject*> Menu::items_data()
{
    return this->m_items;
}

QMenu* Menu::to_qmenu()
{
    QMenu *qmenu = new QMenu;
    qmenu->setTitle(this->title());
    for (int i = 0; i < this->m_items.length(); ++i) {
        MenuItem *item = qobject_cast<MenuItem*>(this->m_items[i]);
        qmenu->addAction(item->to_qaction());
    }

    return qmenu;
}

//==================
// QML Invokables
//==================

void Menu::addItem(QObject *item)
{
    this->m_items.append(item);
}

void Menu::open()
{
    Application::instance()->openMenu(this);
}

} // namespace bl
