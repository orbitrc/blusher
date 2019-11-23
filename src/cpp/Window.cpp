#include "Window.h"

#include <QScreen>

Window::Window(QWindow *parent)
    : QQuickWindow(parent)
{
    this->m_pixelsPerDp = 1;

    QObject::connect(this, &QQuickWindow::screenChanged,
                     this, [this]() { qDebug() << this->screen(); });
}

qreal Window::pixelsPerDp() const
{
    return this->m_pixelsPerDp;
}

void Window::q_onScreenChanged()
{

}

void Window::onScreensChanged()
{

}
