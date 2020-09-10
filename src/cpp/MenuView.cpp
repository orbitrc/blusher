#include "MenuView.h"

#include <QWidget>
#include <QKeyEvent>
#include <QMouseEvent>
#include <QQuickItem>

#include <QDebug>

#include "Blusher.h"
#include "HydrogenStyle.h"
#include "Menu.h"

namespace bl {
MenuView::MenuView(Menu *menu, QWidget *parent)
    : QQuickWidget(parent)
{
    setAttribute(Qt::WA_X11NetWmWindowTypeMenu);
    setWindowFlag(Qt::FramelessWindowHint);
    setWindowFlag(Qt::X11BypassWindowManagerHint);

    setAttribute(Qt::WA_TranslucentBackground);
    setAttribute(Qt::WA_AlwaysStackOnTop);
    setClearColor(Qt::transparent);

    setAttribute(Qt::WA_DeleteOnClose);

    this->m_menuBarMenu = false;
    this->m_menuBarRect = QRectF(0, 0, 100, 10);

    this->m_menu = menu;

    setSource(QUrl("qrc:/qml/Menu.qml"));
    rootObject()->setProperty("menu", QVariant::fromValue(this->m_menu));

    // Reset menu bar rect when menu destroyed.
    Blusher *blusher = Blusher::singleton;
    QObject::connect(this, &QQuickWidget::destroyed,
                     this, [blusher]() {
        blusher->setMenuBarRect(QRectF(0, 0, 0, 0));
        blusher->setMenuBarMenuItemRect(QRectF(0, 0, 0, 0));
    });
}

MenuView::~MenuView()
{
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
        qDebug() << "ESC pressed.";
        close();
        emit this->closedByUser();
    }

    // Prevent round navigation.
    /*
    if (event->key() == Qt::Key_Down &&
            QMenu::activeAction() == QMenu::actions().last()) {
        return;
    }
    if (event->key() == Qt::Key_Up &&
            QMenu::activeAction() == QMenu::actions().first()) {
        return;
    }
    */

    QQuickWidget::keyPressEvent(event);
}

void MenuView::mouseMoveEvent(QMouseEvent *event)
{
    if (Blusher::singleton->menuBarRect().contains(event->screenPos())) {
        if (!Blusher::singleton->menuBarMenuItemRect().contains(event->screenPos())) {
            close();
        }
    }

    QQuickWidget::mouseMoveEvent(event);
}

void MenuView::mousePressEvent(QMouseEvent *event)
{
    close();
    emit this->closedByUser();

    QQuickWidget::mousePressEvent(event);
}

void MenuView::paintEvent(QPaintEvent *evt)
{
    QWindow *window = windowHandle();
    if (window) {
        window->setMouseGrabEnabled(true);
        window->setKeyboardGrabEnabled(true);
    }

    QQuickWidget::paintEvent(evt);
}

} // namespace bl
