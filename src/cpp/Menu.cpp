#include "Menu.h"

#include <QMenu>
#include <QQuickItem>
#include <QScreen>
#include <QWindow>

#include <QDebug>

#include "Blusher.h"
#include "MenuItem.h"
#include "MenuView.h"

namespace bl {

Menu::Menu(QObject *parent)
    : QObject(parent)
{
    this->m_supermenu = nullptr;
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

Menu* Menu::supermenu() const
{
    return this->m_supermenu;
}

void Menu::setSupermenu(Menu *supermenu)
{
    if (this->m_supermenu != supermenu) {
        this->m_supermenu = supermenu;

        emit this->supermenuChanged();
    }
}

QQmlListProperty<MenuItem> Menu::items()
{
    return QQmlListProperty<MenuItem>(this, this->m_items);
    // Above constructor is deprecated. Use below when obsolete.
    // return QQmlListProperty<MenuItem>(this, &this->m_items);
}


MenuView* Menu::to_qmenu()
{
    MenuView *qmenu = new MenuView(this);
    /*
    qmenu->setTitle(this->title());
    for (int i = 0; i < this->m_items.length(); ++i) {
        MenuItem *item = qobject_cast<MenuItem*>(this->m_items[i]);
        qmenu->addAction(item->to_qaction());
    }
    // Open empty menu cause problem on some systems: ubuntu
    if (this->m_items.length() == 0) {
        QAction *dummy_item = new QAction;
        dummy_item->setEnabled(false);
        qmenu->addAction(dummy_item);
    }
    // Delete after closed if it is top level menu.
    if (this->supermenu() == nullptr ||
            this->supermenu()->type() == static_cast<int>(Menu::MenuType::MenuBarMenu)) {
        QObject::connect(qmenu, &QMenu::aboutToHide,
                        qmenu, &QObject::deleteLater);
    }
    */

    return qmenu;
}

//====================
// QQmlParserStatus
//====================

void Menu::classBegin()
{
}

void Menu::componentComplete()
{
}

//==================
// QML Invokables
//==================

void Menu::addItem(MenuItem *item)
{
    this->m_items.append(item);

    emit this->itemsChanged();
}

void Menu::open(double x, double y)
{
//    Blusher::singleton->openMenu(this, x, y);
    MenuView *menuView = new MenuView(this);

    // Connect signal.
    QObject::connect(menuView, &MenuView::closedByUser,
                     Blusher::singleton, &Blusher::menuClosedByUser);

    // Set geometry.
    int screenX = x;
    int screenY = y;
    if (this->parent() && qvariant_cast<QWindow*>(this->parent()->property("window"))) {
        auto window = qvariant_cast<QWindow*>(this->parent()->property("window"));
        screenX += window->screen()->geometry().x();
        screenY += window->screen()->geometry().y();
    }
    auto width = menuView->rootObject()->property("width").toInt();
    auto height = menuView->rootObject()->property("height").toInt();
    menuView->setGeometry(screenX, screenY, width, height);
    menuView->show();
}

} // namespace bl
