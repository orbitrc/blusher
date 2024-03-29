#include "BaseWindow.h"

#include <stdint.h>

#include <blusher/base.h>
#include "DesktopEnvironment.h"
#include "Ewmh.h"
#include "Blusher.h"

#include <QScreen>

namespace bl {

BaseWindow::BaseWindow(QWindow *parent)
    : QQuickWindow(parent)
{
    this->m_netWmStrutPartial = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
    this->m_type = static_cast<int>(BaseWindow::WindowType::Normal);
    this->m_pos.setX(QQuickWindow::x());
    this->m_pos.setY(QQuickWindow::y());
    this->m_size.setWidth(QQuickWindow::width());
    this->m_size.setHeight(QQuickWindow::height());
    this->m_scale = 1;
    this->m_menu = nullptr;
    this->m_anchors.setTop(AnchorLine(this->contentItem()));
    this->m_anchors.setLeft(AnchorLine(this->contentItem()));
    this->m_anchors.setRight(AnchorLine(this->contentItem()));
    this->m_anchors.setBottom(AnchorLine(this->contentItem()));

    QObject::connect(this, &QQuickWindow::screenChanged,
                     this, &BaseWindow::q_onScreenChanged);
    QObject::connect(DesktopEnvironment::singleton, &DesktopEnvironment::screenScaleChanged,
                     this, &BaseWindow::changeScale);

    // Connect signals that window geometry changed by window manager.
    // Not connect to setX signals because prevent circular signal chain.
    QObject::connect(this, &QWindow::xChanged,
                     this, &BaseWindow::q_onXChanged);
    QObject::connect(this, &QWindow::yChanged,
                     this, &BaseWindow::q_onYChanged);
    QObject::connect(this, &QWindow::widthChanged,
                     this, &BaseWindow::q_onWidthChanged);
    QObject::connect(this, &QWindow::heightChanged,
                     this, &BaseWindow::q_onHeightChanged);
}

QList<int> BaseWindow::netWmStrutPartial() const
{
    return this->m_netWmStrutPartial;
}

void BaseWindow::setNetWmStrutPartial(QList<int> value)
{
    if (value.length() == 12) {
        this->m_netWmStrutPartial = value;

#ifdef BL_PLATFORM_LINUX
        Ewmh::set_net_wm_strut_partial(winId(), value);
#endif // BL_BLATFORM_LINUX

        emit this->netWmStrutPartialChanged(value);
    }
}

bool BaseWindow::onAllDesktops() const
{
#ifdef BL_PLATFORM_LINUX
    uint32_t desktop = Ewmh::get_net_wm_desktop(winId());
    if (desktop == 0xFFFFFFFF) {
        return true;
    }
    return false;
#endif // BL_PLATFORM_LINUX
    return false;
}

void BaseWindow::setOnAllDesktops(bool value)
{
#ifdef BL_PLATFORM_LINUX
    if (this->onAllDesktops() != value && value == true) {
        Ewmh::set_net_wm_desktop(winId(), 0xFFFFFFFF);

        emit this->onAllDesktopsChanged(value);
    } else if (this->onAllDesktops() != value && value == false) {
        Ewmh::set_net_wm_desktop(winId(), 1);

        emit this->onAllDesktopsChanged(value);
    }
#endif // BL_PLATFORM_LINUX
}

int BaseWindow::transientFor() const
{
    return this->m_transientFor;
}

void BaseWindow::setTransientFor(int win)
{
    if (this->m_transientFor != win) {
        this->m_transientFor = win;

        if (win != 0) {
            Ewmh::set_wm_transient_for(winId(), win);
        }

        emit this->transientForChanged(win);
    }
}

int BaseWindow::type() const
{
    return this->m_type;
}

void BaseWindow::setType(int type)
{
    if (type != this->m_type) {
        this->m_type = type;

        // No window frame for menu window.
        if (type == static_cast<int>(WindowType::Menu)) {
            QWindow::setFlag(Qt::FramelessWindowHint, true);
            QWindow::setFlag(Qt::Popup, true);
        }

        emit this->typeChanged();
    }
}

int BaseWindow::x() const
{
    return this->m_pos.x();
}

void BaseWindow::setX(int x)
{
    if (this->m_pos.x() != x) {
        this->m_pos.setX(x);

        QQuickWindow::setX(x);

        emit this->xChanged(x);
    }
}

int BaseWindow::y() const
{
    return this->m_pos.y();
}

void BaseWindow::setY(int y)
{
    if (this->m_pos.y() != y) {
        this->m_pos.setY(y);

        QQuickWindow::setY(y);

        emit this->yChanged(y);
    }
}

int BaseWindow::width() const
{
    return this->m_size.width();
}

void BaseWindow::setWidth(int width)
{
    if (this->m_size.width() != width) {
        this->m_size.setWidth(width);

        QQuickWindow::setWidth(width * this->screenScale());

        emit this->widthChanged(width);
    }
}

int BaseWindow::height() const
{
    return this->m_size.height();
}

void BaseWindow::setHeight(int height)
{
    if (this->m_size.height() != height) {
        this->m_size.setHeight(height);

        QQuickWindow::setHeight(height * this->screenScale());

        emit this->heightChanged(height);
    }
}

Menu* BaseWindow::menu() const
{
    return this->m_menu;
}

void BaseWindow::setMenu(Menu *menu)
{
    if (this->m_menu != menu) {
        this->m_menu = menu;

        emit this->menuChanged();
    }
}

qreal BaseWindow::screenScale() const
{
    return this->m_scale;
}

QString BaseWindow::screenName() const
{
    return this->screen()->name();
}

int BaseWindow::windowId() const
{
    return this->winId();
}

AnchorLine BaseWindow::top()
{
    return this->m_anchors.top();
}

AnchorLine BaseWindow::bottom()
{
    return this->m_anchors.bottom();
}


//======================
// Event handlers
//======================
bool BaseWindow::event(QEvent *event)
{
    if (event->type() == QEvent::UpdateRequest) {
        // Grab mouse if window type is menu.
        if (this->type() == static_cast<int>(WindowType::Menu)) {
            QWindow::setMouseGrabEnabled(true);
        }
    }

    return QQuickWindow::event(event);
}

void BaseWindow::keyPressEvent(QKeyEvent *event)
{
    if (this->type() == static_cast<int>(WindowType::Menu) &&
            event->key() == Qt::Key_Escape) {
        QWindow::setMouseGrabEnabled(false);
        QQuickWindow::close();
    }

    // Convert Qt key modifiers to Blusher modifiers.
    using KeyModifier = Blusher::KeyModifier;
    int modifiers = static_cast<int>(KeyModifier::None);
    if (event->modifiers() & Qt::ControlModifier) {
        modifiers |= static_cast<int>(KeyModifier::Control);
    }
    if (event->modifiers() & Qt::AltModifier) {
        modifiers |= static_cast<int>(KeyModifier::Alt);
    }
    if (event->modifiers() & Qt::ShiftModifier) {
        modifiers |= static_cast<int>(KeyModifier::Shift);
    }
    if (event->modifiers() & Qt::MetaModifier) {
        modifiers |= static_cast<int>(KeyModifier::Super);
    }

    KeyEvent *ke = new KeyEvent(modifiers, event->key());
    ke->deleteLater();
    emit this->keyPressed(ke);
    /*
    QObject::connect(ke, &QObject::destroyed,
                     this, []() {
        qDebug() << "destroyed!";
    });
    */

    QQuickWindow::keyPressEvent(event);
}

void BaseWindow::showEvent(QShowEvent *evt)
{
#ifdef BL_PLATFORM_LINUX
    if (this->m_type == static_cast<int>(WindowType::Normal)) {
        return QQuickWindow::showEvent(evt);
    }

    // Set _NET_WM_WINDOW_TYPE.
    switch (this->type()) {
    case static_cast<int>(WindowType::Dock):
        Ewmh::set_net_wm_window_type(winId(), WindowType::Dock);
        break;
    case static_cast<int>(WindowType::Desktop):
        Ewmh::set_net_wm_window_type(winId(), WindowType::Desktop, true);
        break;
    case static_cast<int>(WindowType::Toolbar):
        Ewmh::set_net_wm_window_type(winId(), WindowType::Toolbar);
        break;
    case static_cast<int>(WindowType::Menu):
        Ewmh::set_net_wm_window_type(winId(), WindowType::Menu);
        break;
    case static_cast<int>(WindowType::Utility):
        Ewmh::set_net_wm_window_type(winId(), WindowType::Utility);
        break;
    case static_cast<int>(WindowType::Splash):
        Ewmh::set_net_wm_window_type(winId(), WindowType::Splash);
        break;
    case static_cast<int>(WindowType::Dialog):
        Ewmh::set_net_wm_window_type(winId(), WindowType::Dialog);
        break;
    case static_cast<int>(WindowType::DropDownMenu):
        Ewmh::set_net_wm_window_type(winId(), WindowType::DropDownMenu);
        break;
    case static_cast<int>(WindowType::PopUpMenu):
        Ewmh::set_net_wm_window_type(winId(), WindowType::PopUpMenu);
        break;
    case static_cast<int>(WindowType::ToolTip):
        Ewmh::set_net_wm_window_type(winId(), WindowType::ToolTip);
        break;
    case static_cast<int>(WindowType::Notification):
        Ewmh::set_net_wm_window_type(winId(), WindowType::Notification);
        break;
    case static_cast<int>(WindowType::Combo):
        Ewmh::set_net_wm_window_type(winId(), WindowType::Combo);
        break;
    case static_cast<int>(WindowType::Dnd):
        Ewmh::set_net_wm_window_type(winId(), WindowType::Dnd);
        break;
    default:
        break;
    }
#endif // BL_PLATFORM_LINUX

    return QQuickWindow::showEvent(evt);
}

//=================
// Public slots
//=================
void BaseWindow::changeScale()
{
    ScreenInfo *screen_info = nullptr;
    auto screen_info_list = bl::DesktopEnvironment::singleton->screens();

    // Find screen info.
    for (auto&& info: screen_info_list) {
        if (info->name() == this->screenName()) {
            screen_info = info;
            break;
        }
    }
    qreal scale = screen_info ? screen_info->scale() : 1;
    this->m_scale = scale;

    // Scale window size.
    QWindow::setWidth(this->width() * scale);
    QWindow::setHeight(this->height() * scale);

    emit this->screenScaleChanged(scale);
}

//=================
// Private slots
//=================

void BaseWindow::q_onScreenChanged(QScreen *qscreen)
{
    emit this->screenNameChanged();

    QString screen_name = qscreen->name();

    ScreenInfo *screen_info = nullptr;
    auto screen_info_list = bl::DesktopEnvironment::singleton->screens();

    // Find screen info.
    for (auto&& info: screen_info_list) {
        if (info->name() == screen_name) {
            screen_info = info;
            break;
        }
    }

    if (screen_info == nullptr) {
        qDebug() << "[WARNING] Screen name \"" << screen_name << "\" does not exist.";
        return;
    }
    this->m_scale = screen_info->scale();
    emit this->screenScaleChanged(this->m_scale);
}

void BaseWindow::q_onXChanged(int x)
{
    this->m_pos.setX(x);

    emit this->xChanged(x);
}

void BaseWindow::q_onYChanged(int y)
{
    this->m_pos.setY(y);

    emit this->yChanged(y);
}

void BaseWindow::q_onWidthChanged(int width)
{
    this->m_size.setWidth(width / this->screenScale());

    emit this->widthChanged(width);
}

void BaseWindow::q_onHeightChanged(int height)
{
    this->m_size.setHeight(height / this->screenScale());

    emit this->heightChanged(height);
}

void BaseWindow::onScreensChanged()
{

}

} // namespace bl
