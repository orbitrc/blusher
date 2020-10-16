#include "ScreenInfo.h"

#include <stdio.h>

namespace bl {

ScreenInfo::ScreenInfo(QObject *parent)
    : QObject(parent)
{
    this->m_rect.setX(0);
    this->m_rect.setY(0);
    this->m_rect.setWidth(0);
    this->m_rect.setHeight(0);
    this->m_scale = 1;
}

ScreenInfo::~ScreenInfo()
{
    fprintf(stderr, "ScreenInfo(%s) destroying...\n", this->m_name.toStdString().c_str());
}


QString ScreenInfo::name() const
{
    return this->m_name;
}

void ScreenInfo::setName(const QString &name)
{
    if (this->m_name != name) {
        this->m_name = name;

        emit this->nameChanged(name);
    }
}

int ScreenInfo::x() const
{
    return this->m_rect.x();
}

void ScreenInfo::setX(int x)
{
    if (this->m_rect.x() != x) {
        this->m_rect.setX(x);

        emit this->xChanged(x);
    }
}

int ScreenInfo::y() const
{
    return this->m_rect.y();
}

void ScreenInfo::setY(int y)
{
    if (this->m_rect.y() != y) {
        this->m_rect.setY(y);

        emit this->yChanged(y);
    }
}

int ScreenInfo::width() const
{
    return this->m_rect.width();
}

void ScreenInfo::setWidth(int width)
{
    if (this->m_rect.width() != width) {
        this->m_rect.setWidth(width);

        emit this->widthChanged(width);
    }
}

int ScreenInfo::height() const
{
    return this->m_rect.height();
}

void ScreenInfo::setHeight(int height)
{
    if (this->m_rect.height() != height) {
        this->m_rect.setHeight(height);

        emit this->heightChanged(height);
    }
}

qreal ScreenInfo::scale() const
{
    return this->m_scale;
}

void ScreenInfo::setScale(qreal scale)
{
    if (this->m_scale != scale) {
        this->m_scale = scale;

        emit this->scaleChanged(scale);
    }
}

//=========================
// Public slots
//=========================
void ScreenInfo::onGeometryChanged(const QRect& geometry)
{
    this->setX(geometry.x());
    this->setY(geometry.y());
    this->setWidth(geometry.width());
    this->setHeight(geometry.height());
}

} // namespace bl
