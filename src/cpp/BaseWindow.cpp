#include "BaseWindow.h"

#include <QScreen>

BaseWindow::BaseWindow(QWindow *parent)
    : QQuickWindow(parent)
{
    this->m_type = static_cast<int>(BaseWindow::WindowType::AppWindow);
    this->m_pixelsPerDp = 1;

    QObject::connect(this, &QQuickWindow::screenChanged,
                     this, [this]() { qDebug() << this->screen(); });
}

int BaseWindow::type() const
{
    return this->m_type;
}

void BaseWindow::setType(int type)
{
    if (type != this->m_type) {
        this->m_type = type;

        emit this->typeChanged();
    }
}

qreal BaseWindow::pixelsPerDp() const
{
    return this->m_pixelsPerDp;
}

void BaseWindow::q_onScreenChanged()
{

}

void BaseWindow::onScreensChanged()
{

}
