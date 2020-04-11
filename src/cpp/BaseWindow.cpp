#include "BaseWindow.h"

#include "DesktopEnvironment.h"
#include "Blusher.h"

#include <QScreen>

namespace bl {

BaseWindow::BaseWindow(QWindow *parent)
    : QQuickWindow(parent)
{
    this->m_type = static_cast<int>(BaseWindow::WindowType::AppWindow);
    this->m_pixelsPerDp = 1;

    QObject::connect(this, &QQuickWindow::screenChanged,
                     this, &BaseWindow::q_onScreenChanged);
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

qreal BaseWindow::pixelsPerDp() const
{
    return this->m_pixelsPerDp;
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


void BaseWindow::q_onScreenChanged(QScreen *qscreen)
{
    emit this->screenNameChanged();

    QString screen_name = qscreen->name();

    QVariantMap screens = bl::DesktopEnvironment::singleton->screens();
    if (!screens.contains(screen_name)) {
        qDebug() << "[WARNING] Screen name \"" << screen_name << "\" does not exist.";
    }
    const QVariant& screen = screens[screen_name];
    this->m_pixelsPerDp = screen.toMap()["pixelsPerDp"].toInt();
    emit this->pixelsPerDpChanged();
}

void BaseWindow::onScreensChanged()
{

}

} // namespace bl
