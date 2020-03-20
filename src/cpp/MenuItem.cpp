#include "MenuItem.h"

#include <QMenu>
#include <QAction>

#include "Menu.h"

namespace bl {

MenuItem::MenuItem(QObject *parent)
    : QObject(parent)
{
    this->m_submenu = nullptr;
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

QObject* MenuItem::submenu() const
{
    return this->m_submenu;
}

void MenuItem::setSubmenu(QObject *submenu)
{
    // FIXME: if
    this->m_submenu = submenu;

    emit this->submenuChanged();
}

QAction* MenuItem::to_qaction()
{
    QAction *qaction = new QAction;
    qaction->setText(this->title());
    // Connect action.
    QObject::connect(qaction, &QAction::triggered,
                     this, &MenuItem::triggered);
    // Add submenu.
    if (this->submenu() != nullptr) {
        Menu *submenu = qobject_cast<Menu*>(this->submenu());
        qaction->setMenu(reinterpret_cast<QMenu*>(submenu->to_qmenu()));
    }

    return qaction;
}

} // namespace bl
