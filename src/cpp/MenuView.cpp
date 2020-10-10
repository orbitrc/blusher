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
    this->m_submenu_view = nullptr;

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

    // Close menu views when closing by user.
    QObject::connect(this, &MenuView::aboutToCloseByUser,
                     this, []() {
        MenuView *menu_view = Blusher::singleton->pop_menu_view();
        while (menu_view) {
            menu_view->menu()->close();
            qDebug() << " - Closing " << menu_view->menu()->title();

            menu_view = Blusher::singleton->pop_menu_view();
        }
    });
}

MenuView::~MenuView()
{
    emit this->m_menu->closing();
}


Menu* MenuView::menu()
{
    return this->m_menu;
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

bool MenuView::is_top_level_menu_view() const
{
    // Context menu is top level menu.
    if (this->m_menu->type() == static_cast<int>(Menu::MenuType::ContextualMenu)) {
        return true;
    }
    // If supermenu is menu bar menu, this is a top level menu.
    if (this->is_menu_bar_child()) {
        return true;
    }

    return false;
}

MenuView* MenuView::submenu_view()
{
    return this->m_submenu_view;
}

void MenuView::set_submenu_view(MenuView *menu_view)
{
    this->m_submenu_view = menu_view;
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
    if (event->key() == Qt::Key_Down &&
            this->menu()->activeIndex() == this->menu()->itemsData().length() - 1) {
        return;
    }
    if (event->key() == Qt::Key_Up &&
            this->menu()->activeIndex() == 0) {
        return;
    }

    // Keyboard navigation when index is -1.
    if (event->key() == Qt::Key_Down && this->menu()->activeIndex() == -1) {
        this->menu()->setActiveIndex(0);
        return;
    }
    if (event->key() == Qt::Key_Up && this->menu()->activeIndex() == -1) {
        this->menu()->setActiveIndex(0);
        return;
    }

    // Keyboard navigation.
    if (event->key() == Qt::Key_Down) {
        this->menu()->setActiveIndex(this->menu()->activeIndex() + 1);
    }
    if (event->key() == Qt::Key_Up) {
        this->menu()->setActiveIndex(this->menu()->activeIndex() - 1);
    }

    QQuickWidget::keyPressEvent(event);
}

void MenuView::mouseMoveEvent(QMouseEvent *event)
{
    if (Blusher::singleton->menuBarRect().contains(event->screenPos())) {
        if (!Blusher::singleton->menuBarMenuItemRect().contains(event->screenPos())) {
            // Clear menu view list.
            MenuView* menu_view = Blusher::singleton->pop_menu_view();
            while (menu_view) {
                menu_view->menu()->close();

                menu_view = Blusher::singleton->pop_menu_view();
            }
        }
    }

    // Give the mouse grab to the submenu.
    auto submenu_view = this->m_menu->menuView()->submenu_view();
    if (submenu_view &&
            submenu_view->geometry().contains(static_cast<int>(event->screenPos().x()), static_cast<int>(event->screenPos().y()))
    ) {
        auto window = windowHandle();
        if (window && this->mouseGrabEnabled()) {
            window->setMouseGrabEnabled(false);
            window->setKeyboardGrabEnabled(false);
            this->setMouseGrabEnabled(false);
        }
    }

    QQuickWidget::mouseMoveEvent(event);
}

void MenuView::mousePressEvent(QMouseEvent *event)
{
    emit this->aboutToCloseByUser();
    emit this->closedByUser();
    this->m_menu->close();

    return QQuickWidget::mousePressEvent(event);
}

void MenuView::paintEvent(QPaintEvent *evt)
{
    QWindow *window = windowHandle();

    // Ignore grab if submenu.
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
            window->setMouseGrabEnabled(true);
            window->setKeyboardGrabEnabled(true);
            this->setMouseGrabEnabled(true);
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
//        close();
    }
}

} // namespace bl
