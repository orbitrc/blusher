#include "View.h"

#include "DesktopEnvironment.h"

namespace bl {

View::View(QQuickItem *parent)
    : QQuickItem(parent)
{
    this->m_size.setWidth(0);
    this->m_size.setHeight(0);
    this->m_scaleWidth = true;
    this->m_scaleHeight = true;

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

        qreal scale = (this->scaleWidth())
            ? ((this->window() != nullptr) ? this->window()->screenScale() : 1)
            : 1;
        QQuickItem::setWidth(width * scale);

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

        qreal scale = (this->scaleHeight())
            ? ((this->window() != nullptr) ? this->window()->screenScale() : 1)
            : 1;
        QQuickItem::setHeight(height * scale);

        emit this->heightChanged();
    }
}

bool View::scaleWidth() const
{
    return this->m_scaleWidth;
}

void View::setScaleWidth(bool val)
{
    if (this->m_scaleWidth != val) {
        this->m_scaleWidth = val;

        emit this->scaleWidthChanged();
    }
}

bool View::scaleHeight() const
{
    return this->m_scaleHeight;
}

void View::setScaleHeight(bool val)
{
    if (this->m_scaleHeight != val) {
        this->m_scaleHeight = val;

        emit this->scaleHeightChanged();
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
    // Even x, y are 0, the real positions may not 0 since layout.
    qreal x = this->m_pos.x();
    qreal y = this->m_pos.y();
    if (x != 0) {
        QQuickItem::setX(x * multiple);
    }
    if (y != 0) {
        QQuickItem::setY(this->m_pos.y() * multiple);
    }
    QQuickItem::setWidth(this->m_size.width() * (this->scaleWidth() ? multiple : 1));
    QQuickItem::setHeight(this->m_size.height() * (this->scaleHeight() ? multiple : 1));
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
