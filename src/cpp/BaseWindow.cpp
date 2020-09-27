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
    this->m_netWmWindowType = static_cast<int>(BaseWindow::NetWmWindowType::Normal);
    this->m_type = static_cast<int>(BaseWindow::WindowType::AppWindow);
    this->m_scale = 1;

    QObject::connect(this, &QQuickWindow::screenChanged,
                     this, &BaseWindow::q_onScreenChanged);
    QObject::connect(DesktopEnvironment::singleton, &DesktopEnvironment::screensChanged,
                     this, &BaseWindow::changeScale);
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

int BaseWindow::netWmWindowType() const
{
    return this->m_netWmWindowType;
}

void BaseWindow::setNetWmWindowType(int type)
{
    if (this->m_netWmWindowType != type) {
        this->m_netWmWindowType = type;

        emit this->netWmWindowTypeChanged();
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

qreal BaseWindow::screenScale() const
{
    return this->m_scale;
}

QString BaseWindow::screenName() const
{
    return this->screen()->name();
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
    if (this->m_netWmWindowType == static_cast<int>(NetWmWindowType::Normal)) {
        return QQuickWindow::showEvent(evt);
    }

    // Set _NET_WM_WINDOW_TYPE.
    switch (this->netWmWindowType()) {
    case static_cast<int>(NetWmWindowType::Dock):
        Ewmh::set_net_wm_window_type(winId(), NetWmWindowType::Dock);
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
    QVariantMap screens = bl::DesktopEnvironment::singleton->screens();
    const QVariant& screen = screens[this->screenName()];
    qreal scale = screen.toMap()["scale"].toReal();
    this->m_scale = scale;
    emit this->screenScaleChanged(scale);
}

//=================
// Private slots
//=================

void BaseWindow::q_onScreenChanged(QScreen *qscreen)
{
    emit this->screenNameChanged();

    QString screen_name = qscreen->name();

    QVariantMap screens = bl::DesktopEnvironment::singleton->screens();
    if (!screens.contains(screen_name)) {
        qDebug() << "[WARNING] Screen name \"" << screen_name << "\" does not exist.";
    }
    const QVariant& screen = screens[screen_name];
    this->m_scale = screen.toMap()["scale"].toReal();
    emit this->screenScaleChanged(this->m_scale);
}

void BaseWindow::onScreensChanged()
{

}

} // namespace bl
