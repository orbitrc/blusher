#include "Window.h"

#include <QScreen>

Window::Window(QWindow *parent)
    : QQuickWindow(parent)
{
    this->m_type = static_cast<int>(Window::WindowType::AppWindow);
    this->m_pixelsPerDp = 1;

    QObject::connect(this, &QQuickWindow::screenChanged,
                     this, [this]() { qDebug() << this->screen(); });
}

int Window::type() const
{
    return this->m_type;
}

void Window::setType(int type)
{
    if (type != this->m_type) {
        this->m_type = type;

        emit this->typeChanged();
    }
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
