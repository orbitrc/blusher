#include "View.h"

#include "DesktopEnvironment.h"

namespace bl {

View::View(QQuickItem *parent)
    : QQuickItem(parent)
{
    QObject::connect(this, &QQuickItem::windowChanged,
                     this, &View::onWindowChanged);
}

qreal View::x() const
{
    return this->m_pos.x();
}

void View::setX(qreal x)
{
    if (x != this->m_pos.x()) {
        this->m_pos.setX(x);

        QQuickItem::setX(x);

        emit this->xChanged();
    }
}

qreal View::y() const
{
    return this->m_pos.y();
}

void View::setY(qreal y)
{
    if (y != this->m_pos.y()) {
        this->m_pos.setY(y);

        QQuickItem::setY(y);

        emit this->yChanged();
    }
}

qreal View::width() const
{
    return this->m_size.width();
}

void View::setWidth(qreal width)
{
    if (width != this->m_size.width()) {
        this->m_size.setWidth(width);

        QQuickItem::setWidth(width);

        emit this->widthChanged();
    }
}

qreal View::height() const
{
    return this->m_size.height();
}

void View::setHeight(qreal height)
{
    if (height != this->m_size.height()) {
        this->m_size.setHeight(height);

        QQuickItem::setHeight(height);

        emit this->heightChanged();
    }
}

BaseWindow* View::window() const
{
    return qobject_cast<BaseWindow*>(QQuickItem::window());
}

//==================
// Public slots
//==================
void View::scale(qreal multiple)
{
    QQuickItem::setX(this->m_pos.x() * multiple);
    QQuickItem::setY(this->m_pos.y() * multiple);
    QQuickItem::setWidth(this->m_size.width() * multiple);
    QQuickItem::setHeight(this->m_size.height() * multiple);
}

//==================
// Private slots
//==================
void View::onWindowChanged(QQuickWindow *window)
{
    BaseWindow *baseWindow = qobject_cast<BaseWindow*>(window);
    if (baseWindow) {
        QObject::connect(baseWindow, &BaseWindow::screenScaleChanged,
                         this, &View::scale);
    }
}

} // namespace bl
