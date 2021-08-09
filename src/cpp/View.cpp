#include "View.h"

#include "DesktopEnvironment.h"
#include "BaseWindow.h"

namespace bl {

class View::Impl {
public:
    QMetaObject::Connection anchorsFillXConnection;
    QMetaObject::Connection anchorsFillYConnection;
    QMetaObject::Connection anchorsFillWidthConnection;
    QMetaObject::Connection anchorsFillHeightConnection;

    QMetaObject::Connection anchorsCenterInXConnection;
    QMetaObject::Connection anchorsCenterInYConnection;

    QMetaObject::Connection anchorsTopConnection;
    QMetaObject::Connection anchorsBottomConnection;
    QMetaObject::Connection anchorsTopBottomConnection;
    QMetaObject::Connection anchorsLeftConnection;
    QMetaObject::Connection anchorsRightConnection;
    QMetaObject::Connection anchorsLeftRightConnection;
};

View::View(QQuickItem *parent)
    : QQuickItem(parent)
{
    this->pImpl = new Impl;

    this->m_size.setWidth(0);
    this->m_size.setHeight(0);
    this->m_scaleWidth = true;
    this->m_scaleHeight = true;

    QObject::connect(this, &QQuickItem::windowChanged,
                     this, &View::onWindowChanged);

    // Connect signals that QQuickItem geometry changed by window manager.
    // Not connect to setX signals because prevent circular signal chain.
    QObject::connect(this, &QQuickItem::xChanged,
                     this, &View::q_onXChanged);
    QObject::connect(this, &QQuickItem::yChanged,
                     this, &View::q_onYChanged);
    QObject::connect(this, &QQuickItem::widthChanged,
                     this, &View::q_onWidthChanged);
    QObject::connect(this, &QQuickItem::heightChanged,
                     this, &View::q_onHeightChanged);

    // Anchors.
    this->m_anchors.setHorizontalCenter(AnchorLine(this, AnchorLine::Anchor::HorizontalCenterAnchor));
    this->m_anchors.setVerticalCenter(AnchorLine(this, AnchorLine::Anchor::VerticalCenterAnchor));
    this->m_anchors.setTop(AnchorLine(this, AnchorLine::Anchor::TopAnchor));
    this->m_anchors.setLeft(AnchorLine(this, AnchorLine::Anchor::LeftAnchor));
    this->m_anchors.setRight(AnchorLine(this, AnchorLine::Anchor::RightAnchor));
    this->m_anchors.setBottom(AnchorLine(this, AnchorLine::Anchor::BottomAnchor));
    this->m_anchors.setTopMargin(0);
    this->m_anchors.setLeftMargin(0);
    this->m_anchors.setRightMargin(0);
    this->m_anchors.setBottomMargin(0);

    QObject::connect(&(this->m_anchors), &Anchors::fillChanged,
                     this, &View::adjustAnchors);
    QObject::connect(&(this->m_anchors), &Anchors::centerInChanged,
                     this, &View::adjustAnchors);
    QObject::connect(&(this->m_anchors), &Anchors::topChanged,
                     this, &View::adjustAnchorsTopBottom);
    QObject::connect(&(this->m_anchors), &Anchors::bottomChanged,
                     this, &View::adjustAnchorsTopBottom);
    QObject::connect(&(this->m_anchors), &Anchors::leftChanged,
                     this, &View::adjustAnchorsLeftRight);
    QObject::connect(&(this->m_anchors), &Anchors::rightChanged,
                     this, &View::adjustAnchorsLeftRight);
}

View::~View()
{
    delete this->pImpl;
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

Anchors* View::anchors()
{
    return &(this->m_anchors);
}

AnchorLine View::top()
{
    return this->m_anchors.top();
}

AnchorLine View::left()
{
    return this->m_anchors.left();
}

AnchorLine View::right()
{
    return this->m_anchors.right();
}

AnchorLine View::bottom()
{
    return this->m_anchors.bottom();
}

AnchorLine View::horizontalCenter()
{
    return this->m_anchors.horizontalCenter();
}

AnchorLine View::verticalCenter()
{
    return this->m_anchors.verticalCenter();
}

//===================
// QQmlParserStatus
//===================
void View::componentComplete()
{
    QQuickItem::componentComplete();

    // Initial anchors.fill set.
    if (this->m_anchors.fill() != nullptr) {
        const qreal topMargin = this->m_anchors.topMargin();
        const qreal leftMargin = this->m_anchors.leftMargin();
        const qreal rightMargin = this->m_anchors.rightMargin();
        const qreal bottomMargin = this->m_anchors.bottomMargin();

        this->setX(0 + leftMargin);
        this->setY(0 + topMargin);
        this->setWidth(this->m_anchors.fill()->width() - leftMargin - rightMargin);
        this->setHeight(this->m_anchors.fill()->height() - topMargin - bottomMargin);
    }

    // Initial anchors.top and anchors.bottom set.
    if (this->_has_only_top_anchor()) {
        this->_set_anchors_top();
    }
    if (this->_has_only_bottom_anchor()) {
        this->_set_anchors_bottom();
    }
    if (this->_has_both_top_bottom_anchor()) {
        this->_set_anchors_top_bottom();
    }

    // Initial anchors.left and anchors.right set.
    if (this->_has_only_left_anchor()) {
        this->_set_anchors_left();
    }
    if (this->_has_only_right_anchor()) {
        this->_set_anchors_right();
    }
    if (this->_has_both_left_right_anchor()) {
        this->_set_anchors_left_right();
    }

    // Initial anchors.horizontalCenter set.
    if (this->m_anchors.horizontalCenterAnchorView() != nullptr) {
        this->_set_anchors_horizontal_center();
    }
    if (this->m_anchors.verticalCenterAnchorView() != nullptr) {
        this->_set_anchors_vertical_center();
    }
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

void View::q_onXChanged()
{
    this->m_pos.setX(QQuickItem::x());

    emit this->xChanged();
}

void View::q_onYChanged()
{
    this->m_pos.setY(QQuickItem::y());

    emit this->yChanged();
}

void View::q_onWidthChanged()
{
    this->m_size.setWidth(QQuickItem::width());

    emit this->widthChanged();
}

void View::q_onHeightChanged()
{
    this->m_size.setHeight(QQuickItem::height());

    emit this->heightChanged();
}


void View::adjustAnchors()
{
    // anchors.fill
    if (this->m_anchors.fill() != nullptr) {
        this->adjustAnchorsFill();
    } else {
        this->clearAnchorsFill();
    }
    // anchors.centerIn
    if (this->m_anchors.centerIn() != nullptr) {
        this->adjustAnchorsCenterIn();
    } else {
        this->clearAnchorsCenterIn();
    }
}

void View::clearAnchorsFill()
{
    if (this->pImpl->anchorsFillXConnection) {
        QObject::disconnect(this->pImpl->anchorsFillXConnection);
    }
    if (this->pImpl->anchorsFillYConnection) {
        QObject::disconnect(this->pImpl->anchorsFillYConnection);
    }
    if (this->pImpl->anchorsFillWidthConnection) {
        QObject::disconnect(this->pImpl->anchorsFillWidthConnection);
    }
    if (this->pImpl->anchorsFillHeightConnection) {
        QObject::disconnect(this->pImpl->anchorsFillHeightConnection);
    }
}

void View::adjustAnchorsFill()
{
    this->clearAnchorsFill();

    const qreal topMargin = this->m_anchors.topMargin();
    const qreal leftMargin = this->m_anchors.leftMargin();
    const qreal rightMargin = this->m_anchors.rightMargin();
    const qreal bottomMargin = this->m_anchors.bottomMargin();

    this->pImpl->anchorsFillXConnection =
        QObject::connect(this->m_anchors.fill(), &QQuickItem::xChanged,
                         this, [this, leftMargin]() {
        this->setX(0 + leftMargin);
    });
    this->pImpl->anchorsFillYConnection =
        QObject::connect(this->m_anchors.fill(), &QQuickItem::yChanged,
                         this, [this, topMargin]() {
        this->setY(0 + topMargin);
    });
    this->pImpl->anchorsFillWidthConnection =
        QObject::connect(this->m_anchors.fill(), &QQuickItem::widthChanged,
                         this, [this, leftMargin, rightMargin]() {
        this->setWidth(this->m_anchors.fill()->width() - leftMargin - rightMargin);
    });
    this->pImpl->anchorsFillHeightConnection =
        QObject::connect(this->m_anchors.fill(), &QQuickItem::heightChanged,
                         this, [this, topMargin, bottomMargin]() {
        this->setHeight(this->m_anchors.fill()->height() - topMargin - bottomMargin);
    });
}

void View::clearAnchorsCenterIn()
{
    if (this->pImpl->anchorsCenterInXConnection) {
        QObject::disconnect(this->pImpl->anchorsCenterInXConnection);
    }
    if (this->pImpl->anchorsCenterInYConnection) {
        QObject::disconnect(this->pImpl->anchorsCenterInYConnection);
    }
}

void View::adjustAnchorsCenterIn()
{
    this->clearAnchorsCenterIn();

    this->pImpl->anchorsCenterInXConnection =
        QObject::connect(this->m_anchors.centerIn(), &QQuickItem::xChanged,
                         this, [this]() {
        this->setX((this->m_anchors.centerIn()->width() - this->width()) / 2);
    });
    this->pImpl->anchorsCenterInYConnection =
        QObject::connect(this->m_anchors.centerIn(), &QQuickItem::yChanged,
                         this, [this]() {
        this->setY((this->m_anchors.centerIn()->height() - this->height()) / 2);
    });
}

void View::clearAnchorsTopBottom()
{
    if (this->pImpl->anchorsTopConnection) {
        QObject::disconnect(this->pImpl->anchorsTopConnection);
    }
    if (this->pImpl->anchorsBottomConnection) {
        QObject::disconnect(this->pImpl->anchorsBottomConnection);
    }
    if (this->pImpl->anchorsTopBottomConnection) {
        QObject::disconnect(this->pImpl->anchorsTopBottomConnection);
    }
}

void View::adjustAnchorsTopBottom()
{
    this->clearAnchorsTopBottom();

    // Only top anchor.
    if (this->_has_only_top_anchor()) {
        this->pImpl->anchorsTopConnection =
            QObject::connect(this->m_anchors.topAnchorView(), &QQuickItem::yChanged,
                             this, [this]() {
            this->_set_anchors_top();
        });
    }
    // Only bottom anchor.
    if (this->_has_only_bottom_anchor()) {
        this->pImpl->anchorsBottomConnection =
            QObject::connect(this->m_anchors.bottomAnchorView(), &QQuickItem::heightChanged,
                             this, [this]() {
            this->_set_anchors_bottom();
        });
    }
    // Top and bottom anchors.
    if (this->_has_both_top_bottom_anchor()) {
        this->pImpl->anchorsTopBottomConnection =
            QObject::connect(this->m_anchors.topAnchorView(), &QQuickItem::heightChanged,
                             this, [this]() {
            this->_set_anchors_top_bottom();
        });
    }
}

void View::clearAnchorsLeftRight()
{
    if (this->pImpl->anchorsLeftConnection) {
        QObject::disconnect(this->pImpl->anchorsLeftConnection);
    }
    if (this->pImpl->anchorsRightConnection) {
        QObject::disconnect(this->pImpl->anchorsRightConnection);
    }
    if (this->pImpl->anchorsLeftRightConnection) {
        QObject::disconnect(this->pImpl->anchorsLeftRightConnection);
    }
}

void View::adjustAnchorsLeftRight()
{
    this->clearAnchorsLeftRight();

    // Only left anchor.
    if (this->_has_only_left_anchor()) {
        this->pImpl->anchorsLeftConnection =
            QObject::connect(this->m_anchors.leftAnchorView(), &QQuickItem::xChanged,
                             this, [this]() {
            this->_set_anchors_left();
        });
    }
    // Only right anchor.
    if (this->_has_only_right_anchor()) {
        this->pImpl->anchorsRightConnection =
            QObject::connect(this->m_anchors.rightAnchorView(), &QQuickItem::widthChanged,
                             this, [this]() {
            this->_set_anchors_right();
        });
    }
    // Left and right anchors.
    if (this->_has_both_left_right_anchor()) {
        this->pImpl->anchorsLeftRightConnection =
            QObject::connect(this->m_anchors.leftAnchorView(), &QQuickItem::widthChanged,
                             this, [this]() {
            this->_set_anchors_left_right();
        });
    }
}

//===========================
// Private methods.
//===========================

bool View::_has_only_top_anchor()
{
    if (this->m_anchors.topAnchorView() != nullptr &&
            this->m_anchors.bottomAnchorView() == nullptr) {
        return true;
    }

    return false;
}

bool View::_has_only_bottom_anchor()
{
    if (this->m_anchors.bottomAnchorView() != nullptr &&
            this->m_anchors.topAnchorView() == nullptr) {
        return true;
    }

    return false;
}

bool View::_has_both_top_bottom_anchor()
{
    if (this->m_anchors.topAnchorView() != nullptr &&
            this->m_anchors.bottomAnchorView() != nullptr) {
        return true;
    }

    return false;
}

bool View::_has_only_left_anchor()
{
    if (this->m_anchors.leftAnchorView() != nullptr &&
            this->m_anchors.rightAnchorView() == nullptr) {
        return true;
    }

    return false;
}

bool View::_has_only_right_anchor()
{
    if (this->m_anchors.rightAnchorView() != nullptr &&
            this->m_anchors.leftAnchorView() == nullptr) {
        return true;
    }

    return false;
}

bool View::_has_both_left_right_anchor()
{
    if (this->m_anchors.leftAnchorView() != nullptr &&
            this->m_anchors.rightAnchorView() != nullptr) {
        return true;
    }

    return false;
}

void View::_set_anchors_top()
{
    const BaseWindow *window = qobject_cast<BaseWindow*>(this->window());
    const QQuickItem *body = (window
        ? window->contentItem()->childItems()[1]
        : nullptr);
   const QQuickItem *anchorView = this->m_anchors.topAnchorView();
   const qreal topMargin = this->m_anchors.topMargin();
   qreal menuBarOffset = 0;

   if (this->m_anchors.topAnchor() == AnchorLine::Anchor::TopAnchor) {
       if (window && body == anchorView) {
           menuBarOffset = 30;
       }
       this->setY(anchorView->y() - menuBarOffset + topMargin);
   } else if (this->m_anchors.topAnchor() == AnchorLine::Anchor::BottomAnchor) {
       this->setY(anchorView->y() + this->height() + topMargin);
   }
}

void View::_set_anchors_bottom()
{
    QQuickItem *anchorView = this->m_anchors.bottomAnchorView();
    const qreal bottomMargin = this->m_anchors.bottomMargin();

    if (this->m_anchors.bottomAnchor() == AnchorLine::Anchor::BottomAnchor) {
        this->setY(anchorView->height() - this->height() - bottomMargin);
    } else if (this->m_anchors.bottomAnchor() == AnchorLine::Anchor::TopAnchor) {
        this->setY(anchorView->y() - this->height() - bottomMargin);
    }
}

void View::_set_anchors_top_bottom()
{
    const BaseWindow *window = qobject_cast<BaseWindow*>(this->window());
    const QQuickItem *body = (window
        ? window->contentItem()->childItems()[1]
        : nullptr);
    qreal menu_bar_offset = 0;
    qreal height = 0;
    if (window && body == this->m_anchors.topAnchorView()) {
        menu_bar_offset = 30;
        height = window->height() - menu_bar_offset;
    } else {
        height = this->m_anchors.topAnchorView()->height();
    }
    this->setY(this->m_anchors.topAnchorView()->y() - menu_bar_offset);
    this->setHeight(height);
}

void View::_set_anchors_left()
{
    QQuickItem *anchorView = this->m_anchors.leftAnchorView();
    QQuickItem *parent = this->parentItem();
    const qreal leftMargin = this->m_anchors.leftMargin();

    if (this->m_anchors.leftAnchor() == AnchorLine::Anchor::LeftAnchor) {
        if (parent == anchorView) {
            // If anchored item is parent item, start x from 0.
            this->setX(0 + leftMargin);
        } else {
            this->setX(anchorView->x() + leftMargin);
        }
    } else if (this->m_anchors.leftAnchor() == AnchorLine::Anchor::RightAnchor) {
        this->setX(anchorView->x() + anchorView->width() + leftMargin);
    }
}

void View::_set_anchors_right()
{
    QQuickItem *anchorView = this->m_anchors.rightAnchorView();
    const qreal rightMargin = this->m_anchors.rightMargin();

    if (this->m_anchors.rightAnchor() == AnchorLine::Anchor::RightAnchor) {
        this->setX(anchorView->width() - this->width() - rightMargin);
    } else if (this->m_anchors.rightAnchor() == AnchorLine::Anchor::LeftAnchor) {
        this->setX(anchorView->x() - anchorView->width() - rightMargin);
    }
}

void View::_set_anchors_left_right()
{
    QQuickItem *anchorView = this->m_anchors.leftAnchorView();
    const qreal leftMargin = this->m_anchors.leftMargin();
    const qreal rightMargin = this->m_anchors.rightMargin();

    this->setX(anchorView->x() - leftMargin);
    this->setWidth(anchorView->width() - leftMargin - rightMargin);
}

void View::_set_anchors_horizontal_center()
{
    QQuickItem *anchorView = this->m_anchors.horizontalCenterAnchorView();

    if (this->m_anchors.horizontalCenterAnchor() == AnchorLine::Anchor::HorizontalCenterAnchor) {
        this->setX((anchorView->width() - this->width()) / 2);
    }
}

void View::_set_anchors_vertical_center()
{
    QQuickItem *anchorView = this->m_anchors.verticalCenterAnchorView();

    if (this->m_anchors.verticalCenterAnchor() == AnchorLine::Anchor::VerticalCenterAnchor) {
        this->setY((anchorView->height() - this->height()) / 2);
    }
}

} // namespace bl
