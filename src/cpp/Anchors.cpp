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
    this->m_topAnchorView = nullptr;
    this->m_leftAnchorView = nullptr;
    this->m_rightAnchorView = nullptr;
    this->m_bottomAnchorView = nullptr;
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

QQuickItem* Anchors::topAnchorView()
{
    return this->m_topAnchorView;
}

QQuickItem* Anchors::leftAnchorView()
{
    return this->m_leftAnchorView;
}

QQuickItem* Anchors::rightAnchorView()
{
    return this->m_rightAnchorView;
}

QQuickItem* Anchors::bottomAnchorView()
{
    return this->m_bottomAnchorView;
}

AnchorLine Anchors::top()
{
    return this->m_top;
}

void Anchors::setTop(const AnchorLine &top)
{
    // Init.
    if (this->m_top.view == nullptr) {
        this->m_top.view = top.view;
    }
    // Clear.
    if (this->m_topAnchorView != nullptr && this->m_bottom.view == top.view) {
        this->m_topAnchorView = nullptr;

        emit this->topChanged();
        return;
    }
    // Do not emit if already cleared.
    if (this->m_top.view == top.view) {
        return;
    }

    if (this->m_topAnchorView != top.view) {
        if (top.view == this->m_top.view) {
            // If top anchor line's view is THIS.
            this->m_topAnchorView = nullptr;
        } else {
            this->m_topAnchorView = top.view;
        }

        emit this->topChanged();
    }
}

AnchorLine Anchors::left()
{
    return this->m_left;
}

void Anchors::setLeft(const AnchorLine &left)
{
    // Init.
    if (this->m_left.view == nullptr) {
        this->m_left.view = left.view;
    }
    // Clear.
    if (this->m_leftAnchorView != nullptr && this->m_left.view == left.view) {
        this->m_leftAnchorView = nullptr;

        emit this->leftChanged();
        return;
    }
    // Do not emit if already cleared.
    if (this->m_left.view == left.view) {
        return;
    }

    if (this->m_leftAnchorView != left.view) {
        if (left.view == this->m_left.view) {
            // If left anchor line's view is THIS.
            this->m_leftAnchorView = nullptr;
        } else {
            this->m_leftAnchorView = left.view;
        }

        emit this->leftChanged();
    }
}

AnchorLine Anchors::right()
{
    return this->m_right;
}

void Anchors::setRight(const AnchorLine &right)
{
    // Init.
    if (this->m_right.view == nullptr) {
        this->m_right.view = right.view;
    }
    // Clear.
    if (this->m_rightAnchorView != nullptr && this->m_right.view == right.view) {
        this->m_rightAnchorView = nullptr;

        emit this->rightChanged();
        return;
    }
    // Do not emit if already cleared.
    if (this->m_right.view == right.view) {
        return;
    }

    if (this->m_rightAnchorView != right.view) {
        if (right.view == this->m_right.view) {
            // If right anchor line's view is THIS.
            this->m_rightAnchorView = nullptr;
        } else {
            this->m_rightAnchorView = right.view;
        }

        emit this->rightChanged();
    }
}

AnchorLine Anchors::bottom()
{
    return this->m_bottom;
}

void Anchors::setBottom(const AnchorLine &bottom)
{
    // Init.
    if (this->m_bottom.view == nullptr) {
        this->m_bottom.view = bottom.view;

        return;
    }
    // Clear.
    if (this->m_bottomAnchorView != nullptr && this->m_bottom.view == bottom.view) {
        this->m_bottomAnchorView = nullptr;

        emit this->bottomChanged();
        return;
    } else if (this->m_bottomAnchorView == nullptr && this->m_bottom.view == bottom.view) {
        // Do not emit if already cleared.
        return;
    }

    if (this->m_bottomAnchorView != bottom.view) {
        if (bottom.view == this->m_bottom.view) {
            // If bottom anchor line's view is THIS.
            this->m_bottomAnchorView = nullptr;
        } else {
            this->m_bottomAnchorView = bottom.view;
        }

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
