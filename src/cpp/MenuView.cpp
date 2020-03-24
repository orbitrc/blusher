#include "MenuView.h"

#include <QWidget>
#include <QKeyEvent>
#include <QMouseEvent>

#include <QDebug>

#include <blusher/Application.h>

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
    // Emit signal when Esc key pressed.
    if (event->key() == Qt::Key_Escape) {
        emit this->closedByUser();
    }

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
    if (Application::instance()->menuBarRect().contains(event->screenPos())) {
        if (!Application::instance()->menuBarMenuItemRect().contains(event->screenPos())) {
            this->close();
        }
    }

    QMenu::mouseMoveEvent(event);
}

void MenuView::mousePressEvent(QMouseEvent *event)
{
    emit this->closedByUser();

    QMenu::mousePressEvent(event);
}

} // namespace bl
