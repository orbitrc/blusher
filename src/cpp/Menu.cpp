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
    this->m_activeIndex = -1;
    this->m_opened = false;

    this->m_menuView = nullptr;
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

QList<MenuItem*> Menu::itemsData() const
{
    return this->m_items;
}

bool Menu::opened() const
{
    return this->m_opened;
}

int Menu::activeIndex() const
{
    return this->m_activeIndex;
}

void Menu::setActiveIndex(int index)
{
    if (this->m_activeIndex != index) {
        this->m_activeIndex = index;

        emit this->activeIndexChanged(index);
    }
}

MenuView* Menu::menuView()
{
    return this->m_menuView;
}

void Menu::setMenuView(MenuView *menuView)
{
    this->m_menuView = menuView;
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
    this->setMenuView(menuView);

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

    // Append to the menu view list.
    Blusher::singleton->append_menu_view(menuView);

    // Property change.
    this->m_opened = true;
    emit this->openedChanged(true);

    // Set supermenu's submenu view if this is submenu.
    auto supermenu = this->supermenu();
    if (supermenu && supermenu->type() != static_cast<int>(Menu::MenuType::MenuBarMenu)) {
        supermenu->menuView()->set_submenu_view(menuView);
    }
}

void Menu::close()
{
    this->menuView()->close();
    this->m_opened = false;
    emit this->openedChanged(false);
}

} // namespace bl
