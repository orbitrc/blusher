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

    this->m_mouseGrabEnabled = false;

    this->m_menu = menu;

    setSource(QUrl("qrc:/qml/Menu.qml"));
    rootObject()->setProperty("menu", QVariant::fromValue(this->m_menu));
    // Connect signals for mouse grab.
    QObject::connect(rootObject(), SIGNAL(menuEntered()),
                     this, SLOT(onMenuEntered()));
    QObject::connect(rootObject(), SIGNAL(menuLeaved()),
                     this, SLOT(onMenuLeaved()));

    // Reset menu bar rect when menu destroyed.
    Blusher *blusher = Blusher::singleton;
    QObject::connect(this, &QQuickWidget::destroyed,
                     this, [blusher]() {
        blusher->setMenuBarRect(QRectF(0, 0, 0, 0));
        blusher->setMenuBarMenuItemRect(QRectF(0, 0, 0, 0));
    });

    // Close supermenus when closing.
    if (this->m_menu->type() == static_cast<int>(Menu::MenuType::Submenu)) {
        QObject::connect(this, &MenuView::closedByUser,
                         this, [this]() {
            auto supermenu = this->m_menu->supermenu();
            if (supermenu && supermenu->menuView()) {
                supermenu->menuView()->close();
            }
            supermenu->setMenuView(nullptr);
        });
    }
}

MenuView::~MenuView()
{
    emit this->m_menu->closing();
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

bool MenuView::mouseGrabEnabled() const
{
    return this->m_mouseGrabEnabled;
}

void MenuView::setMouseGrabEnabled(bool value)
{
    if (this->m_mouseGrabEnabled != value) {
        this->m_mouseGrabEnabled = value;
    }
}


bool MenuView::is_menu_bar_child() const
{
    auto supermenu = this->m_menu->supermenu();
    if (supermenu &&
            supermenu->type() == static_cast<int>(Menu::MenuType::MenuBarMenu)) {
        return true;
    }

    return false;
}

//========================
// Event handlers
//========================

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

    // Ignore if submenu.
    auto supermenu = this->m_menu->supermenu();
    if ((supermenu && supermenu->type() != static_cast<int>(Menu::MenuType::MenuBarMenu)) &&
            this->m_menu->type() == static_cast<int>(Menu::MenuType::Submenu)) {
        return QQuickWidget::paintEvent(evt);
    }

    if (window && !this->m_mouseGrabEnabled) {
        window->setMouseGrabEnabled(true);
        window->setKeyboardGrabEnabled(true);
        this->m_mouseGrabEnabled = true;
    }

    return QQuickWidget::paintEvent(evt);
}

//====================
// Private slots
//====================
void MenuView::onMenuEntered()
{
    // Enable mouse grab.
    if (this->m_menu->type() == static_cast<int>(Menu::MenuType::Submenu)) {
        QWindow *window = windowHandle();
        if (window) {
        }
    }
}

void MenuView::onMenuLeaved()
{
    // Ignore menu bar child.
    if (this->is_menu_bar_child()) {
        return;
    }

    // Disable mouse grab.
    if (this->m_menu->type() == static_cast<int>(Menu::MenuType::Submenu)) {
        QWindow *window = windowHandle();
        if (window) {
            window->setMouseGrabEnabled(false);
            window->setKeyboardGrabEnabled(false);
            this->m_mouseGrabEnabled = false;
        }
        // Give back mouse grab to the supermenu.
        auto supermenu = this->m_menu->supermenu();
        if (supermenu) {
            auto menu_view = supermenu->menuView();
            if (menu_view) {
                window = menu_view->windowHandle();
                if (window) {
                    window->setMouseGrabEnabled(true);
                    window->setKeyboardGrabEnabled(true);
                    menu_view->setMouseGrabEnabled(true);
                }
            }
        }
        close();
    }
}

} // namespace bl
