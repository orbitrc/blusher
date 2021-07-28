#include "View.h"

#include "DesktopEnvironment.h"

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
    QMetaObject::Connection anchorsLeftConnection;
    QMetaObject::Connection anchorsRightConnection;
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
    // Anchors.
    this->m_anchors.setHorizontalCenter(AnchorLine(this));
    this->m_anchors.setVerticalCenter(AnchorLine(this));
    this->m_anchors.setTop(AnchorLine(this));
    this->m_anchors.setLeft(AnchorLine(this));
    this->m_anchors.setRight(AnchorLine(this));
    this->m_anchors.setBottom(AnchorLine(this));
    this->m_horizontalCenter = AnchorLine(this);
    this->m_verticalCenter = AnchorLine(this);

    QObject::connect(&(this->m_anchors), &Anchors::fillChanged,
                     this, &View::adjustAnchors);
    QObject::connect(&(this->m_anchors), &Anchors::centerInChanged,
                     this, &View::adjustAnchors);
    QObject::connect(&(this->m_anchors), &Anchors::topChanged,
                     this, &View::adjustAnchors);
    QObject::connect(&(this->m_anchors), &Anchors::bottomChanged,
                     this, &View::adjustAnchors);
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
    return this->m_horizontalCenter;
}

AnchorLine View::verticalCenter()
{
    return this->m_verticalCenter;
}

//===================
// QQmlParserStatus
//===================
void View::componentComplete()
{
    QQuickItem::componentComplete();

    if (this->m_anchors.bottomAnchorView() != nullptr) {
        this->setY(this->m_anchors.bottomAnchorView()->height() - this->height());
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
    // anchors.top and anchors.bottom
    if (this->m_anchors.top().view != this) {
        this->adjustAnchorsTopBottom();
    } else {
        this->m_anchors.setTop(AnchorLine(this));
        this->clearAnchorsTopBottom();
    }
    if (this->m_anchors.bottomAnchorView() != this) {
        this->adjustAnchorsTopBottom();
    } else {
        this->m_anchors.setBottom(AnchorLine(this));
        this->clearAnchorsTopBottom();
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

    this->pImpl->anchorsFillXConnection =
        QObject::connect(this->m_anchors.fill(), &QQuickItem::xChanged,
                         this, [this]() {
        this->setX(this->m_anchors.fill()->x());
    });
    this->pImpl->anchorsFillYConnection =
        QObject::connect(this->m_anchors.fill(), &QQuickItem::yChanged,
                         this, [this]() {
        this->setY(this->m_anchors.fill()->y());
    });
    this->pImpl->anchorsFillWidthConnection =
        QObject::connect(this->m_anchors.fill(), &QQuickItem::widthChanged,
                         this, [this]() {
        this->setWidth(this->m_anchors.fill()->width());
    });
    this->pImpl->anchorsFillHeightConnection =
        QObject::connect(this->m_anchors.fill(), &QQuickItem::heightChanged,
                         this, [this]() {
        this->setHeight(this->m_anchors.fill()->height());
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
    if (this->m_anchors.top().view == this && this->pImpl->anchorsTopConnection) {
        QObject::disconnect(this->pImpl->anchorsTopConnection);
    }
    if (this->m_anchors.bottom().view == this && this->pImpl->anchorsBottomConnection) {
        QObject::disconnect(this->pImpl->anchorsBottomConnection);
    }
}

void View::adjustAnchorsTopBottom()
{
    this->clearAnchorsTopBottom();

    if (this->m_anchors.topAnchorView() != nullptr) {
        this->setY(this->m_anchors.top().view->y());
        this->pImpl->anchorsTopConnection =
            QObject::connect(this->m_anchors.top().view, &QQuickItem::yChanged,
                             this, [this]() {
            this->setY(this->m_anchors.top().view->y());
        });
    }
    if (this->m_anchors.bottomAnchorView() != nullptr) {
        this->pImpl->anchorsBottomConnection =
            QObject::connect(this->m_anchors.bottomAnchorView(), &QQuickItem::heightChanged,
                             this, [this]() {
            this->setY(this->m_anchors.bottomAnchorView()->height() - this->height());
        });
    }
}

void View::clearAnchorsLeftRight()
{}

void View::adjustAnchorsLeftRight()
{}

} // namespace bl
