#include "Anchors.h"

#include "View.h"

namespace bl {

// AnchorLine.
AnchorLine::AnchorLine(QQuickItem *view, Anchor anchor)
{
    this->view = view;
    this->anchor = anchor;
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

    this->m_topAnchor = AnchorLine::Anchor::None;
    this->m_leftAnchor = AnchorLine::Anchor::None;
    this->m_rightAnchor = AnchorLine::Anchor::None;
    this->m_bottomAnchor = AnchorLine::Anchor::None;
    this->m_horizontalCenterAnchor = AnchorLine::Anchor::None;
    this->m_verticalCenterAnchor = AnchorLine::Anchor::None;
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


AnchorLine::Anchor Anchors::topAnchor() const
{
    return this->m_topAnchor;
}

AnchorLine::Anchor Anchors::leftAnchor() const
{
    return this->m_leftAnchor;
}

AnchorLine::Anchor Anchors::rightAnchor() const
{
    return this->m_rightAnchor;
}

AnchorLine::Anchor Anchors::bottomAnchor() const
{
    return this->m_bottomAnchor;
}

AnchorLine::Anchor Anchors::horizontalCenterAnchor() const
{
    return this->m_horizontalCenterAnchor;
}

AnchorLine::Anchor Anchors::verticalCenterAnchor() const
{
    return this->m_verticalCenterAnchor;
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
        this->m_top.anchor = top.anchor;
    }
    // Clear.
    if (this->m_topAnchorView != nullptr && this->m_bottom.view == top.view) {
        this->m_topAnchorView = nullptr;
        this->m_topAnchor = AnchorLine::Anchor::None;

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
            this->m_topAnchor = AnchorLine::Anchor::None;
        } else {
            this->m_topAnchorView = top.view;
            this->m_topAnchor = top.anchor;
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
        this->m_left.anchor = left.anchor;
    }
    // Clear.
    if (this->m_leftAnchorView != nullptr && this->m_left.view == left.view) {
        this->m_leftAnchorView = nullptr;
        this->m_leftAnchor = AnchorLine::Anchor::None;

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
            this->m_leftAnchor = AnchorLine::Anchor::None;
        } else {
            this->m_leftAnchorView = left.view;
            this->m_leftAnchor = left.anchor;
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
        this->m_right.anchor = right.anchor;
    }
    // Clear.
    if (this->m_rightAnchorView != nullptr && this->m_right.view == right.view) {
        this->m_rightAnchorView = nullptr;
        this->m_rightAnchor = AnchorLine::Anchor::None;

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
            this->m_rightAnchor = AnchorLine::Anchor::None;
        } else {
            this->m_rightAnchorView = right.view;
            this->m_rightAnchor = right.anchor;
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
        this->m_bottom.anchor = bottom.anchor;

        return;
    }
    // Clear.
    if (this->m_bottomAnchorView != nullptr && this->m_bottom.view == bottom.view) {
        this->m_bottomAnchorView = nullptr;
        this->m_bottomAnchor = AnchorLine::Anchor::None;

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
            this->m_bottomAnchor = AnchorLine::Anchor::None;
        } else {
            this->m_bottomAnchorView = bottom.view;
            this->m_bottomAnchor = bottom.anchor;
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

qreal Anchors::topMargin() const
{
    return this->m_topMargin;
}

void Anchors::setTopMargin(qreal topMargin)
{
    if (this->m_topMargin != topMargin) {
        this->m_topMargin = topMargin;

        emit this->topMarginChanged(topMargin);
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

qreal Anchors::rightMargin() const
{
    return this->m_rightMargin;
}

void Anchors::setRightMargin(qreal rightMargin)
{
    if (this->m_rightMargin != rightMargin) {
        this->m_rightMargin = rightMargin;

        emit this->rightMarginChanged(rightMargin);
    }
}

qreal Anchors::bottomMargin() const
{
    return this->m_bottomMargin;
}

void Anchors::setBottomMargin(qreal bottomMargin)
{
    if (this->m_bottomMargin != bottomMargin) {
        this->m_bottomMargin = bottomMargin;

        emit this->bottomMarginChanged(bottomMargin);
    }
}

} // namespace bl
