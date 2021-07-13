#include "Anchors.h"

#include "View.h"

namespace bl {

// AnchorLine.
AnchorLine::AnchorLine(QQuickItem *view)
{
    this->view = view;
}

void AnchorLine::setView(QQuickItem *view)
{
    this->view = view;
}

// Anchors.

Anchors::Anchors(QObject *parent)
    : QObject(parent)
{
    this->m_fill = nullptr;
    this->m_centerIn = nullptr;
}

QQuickItem* Anchors::fill() const
{
    return this->m_fill;
}

void Anchors::setFill(QQuickItem *view)
{
    if (this->m_fill != view) {
        this->m_fill = view;

        emit this->fillChanged();
    }
}

QQuickItem* Anchors::centerIn() const
{
    return this->m_centerIn;
}

void Anchors::setCenterIn(QQuickItem *view)
{
    if (this->m_centerIn != view) {
        this->m_centerIn = view;

        emit this->centerInChanged();
    }
}

AnchorLine Anchors::top()
{
    return this->m_top;
}

void Anchors::setTop(const AnchorLine &top)
{
    if (this->m_top.view != top.view) {
        this->m_top.view = top.view;

        emit this->topChanged();
    }
}

AnchorLine Anchors::left()
{
    return this->m_left;
}

void Anchors::setLeft(const AnchorLine &left)
{
    if (this->m_left.view != left.view) {
        this->m_left.view = left.view;

        emit this->leftChanged();
    }
}

AnchorLine Anchors::right()
{
    return this->m_right;
}

void Anchors::setRight(const AnchorLine &right)
{
    if (this->m_right.view != right.view) {
        this->m_right.view = right.view;

        emit this->rightChanged();
    }
}

AnchorLine Anchors::bottom()
{
    return this->m_bottom;
}

void Anchors::setBottom(const AnchorLine &bottom)
{
    if (this->m_bottom.view != bottom.view) {
        this->m_bottom.view = bottom.view;

        emit this->bottomChanged();
    }
}

AnchorLine Anchors::horizontalCenter()
{
    return this->m_horizontalCenter;
}

void Anchors::setHorizontalCenter(const AnchorLine& hCenter)
{
    if (this->m_horizontalCenter.view != hCenter.view) {
        this->m_horizontalCenter.view = hCenter.view;

        emit this->horizontalCenterChanged();
    }
}

AnchorLine Anchors::verticalCenter()
{
    return this->m_verticalCenter;
}

void Anchors::setVerticalCenter(const AnchorLine &vCenter)
{
    if (this->m_verticalCenter.view != vCenter.view) {
        this->m_verticalCenter.view = vCenter.view;

        emit this->verticalCenterChanged();
    }
}

qreal Anchors::leftMargin() const
{
    return this->m_leftMargin;
}

void Anchors::setLeftMargin(qreal leftMargin)
{
    if (this->m_leftMargin != leftMargin) {
        this->m_leftMargin = leftMargin;

        emit this->leftMarginChanged(leftMargin);
    }
}

} // namespace bl
