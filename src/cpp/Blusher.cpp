#include "Blusher.h"

#include <QApplication>
#include <QClipboard>

#include "MenuView.h"

namespace bl {

Blusher *Blusher::singleton = nullptr;

Blusher::Blusher(QObject *parent)
    : QObject(parent)
{
}

QApplication* Blusher::app() const
{
    return qobject_cast<QApplication*>(QApplication::instance());
}

void Blusher::_set_app(QObject *app)
{
    this->p_app = app;
}

void Blusher::copyTextToClipboard(QString text)
{
    this->app()->clipboard()->setText(text);
}

QRectF Blusher::menuBarRect() const
{
    return this->m_menuBarRect;
}

void Blusher::setMenuBarRect(QRectF rect)
{
    this->m_menuBarRect = rect;
}

QRectF Blusher::menuBarMenuItemRect() const
{
    return this->m_menuBarMenuItemRect;
}

void Blusher::setMenuBarMenuItemRect(QRectF rect)
{
    this->m_menuBarMenuItemRect = rect;
}

void Blusher::openMenu(bl::Menu *menu, double x, double y)
{
    MenuView *qmenu = menu->to_qmenu();
    QObject::connect(qmenu, &MenuView::closedByUser,
                     this, &Blusher::menuClosedByUser);
//    qmenu->popup(QPoint(x, y));
}

void Blusher::append_menu_view(MenuView *menu_view)
{
    this->m_menu_views.append(menu_view);
}

MenuView* Blusher::pop_menu_view()
{
    MenuView *menu_view = nullptr;
    if (!this->m_menu_views.isEmpty()) {
        menu_view = this->m_menu_views.last();
        this->m_menu_views.pop_back();
    }

    return menu_view;
}

} // namespace bl
