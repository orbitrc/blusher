#include "MenuView.h"

#include <QWidget>
#include <QKeyEvent>
#include <QMouseEvent>

#include <QDebug>

namespace bl {
MenuView::MenuView(QWidget *parent)
    : QMenu(parent)
{
    this->m_menuBarMenu = false;
    this->m_menuBarRect = QRectF(0, 0, 100, 10);
}

bool MenuView::isMenuBarMenu() const
{
    return this->m_menuBarMenu;
}

void MenuView::setMenuBarMenu(bool value)
{
    this->m_menuBarMenu = value;
}

QRectF MenuView::menuBarRect() const
{
    return this->m_menuBarRect;
}

void MenuView::setMenuBarRect(QRectF rect)
{
    this->m_menuBarRect = rect;
}

void MenuView::keyPressEvent(QKeyEvent *event)
{
    // Prevent round navigation.
    if (event->key() == Qt::Key_Down &&
            QMenu::activeAction() == QMenu::actions().last()) {
        return;
    }
    if (event->key() == Qt::Key_Up &&
            QMenu::activeAction() == QMenu::actions().first()) {
        return;
    }

    QMenu::keyPressEvent(event);
}

void MenuView::mouseMoveEvent(QMouseEvent *event)
{
    if (this->isMenuBarMenu()) {
        if (this->menuBarRect().contains(event->x(), event->y())) {
            qDebug() << "MenuBar area!";
            return;
        }
    }

    QMenu::mouseMoveEvent(event);
}

} // namespace bl
