#include "BaseWindow.h"

#include <QScreen>

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
    QQuickWindow::keyPressEvent(event);
}


void BaseWindow::q_onScreenChanged(QScreen *qscreen)
{
    qDebug() << qscreen;
}

void BaseWindow::onScreensChanged()
{

}
