#include "Box.h"

#include <QPainter>
#include <QPainterPath>
#include <QSGSimpleTextureNode>

namespace bl {

Box::Box(QQuickItem *parent)
    : View(parent)
{
    setFlag(QQuickItem::ItemHasContents);

    this->m_color = Qt::white;
    this->m_topLeftRadius = 0;
    this->m_topRightRadius = 0;
    this->m_bottomLeftRadius = 0;
    this->m_bottomRightRadius = 0;
}

QColor Box::color() const
{
    return this->m_color;
}

void Box::setColor(const QColor &color)
{
    if (this->m_color != color) {
        this->m_color = color;

        emit this->colorChanged();
    }
}

qreal Box::topLeftRadius() const
{
    return this->m_topLeftRadius;
}

void Box::setTopLeftRadius(qreal value)
{
    if (this->m_topLeftRadius != value) {
        this->m_topLeftRadius = value;

        emit this->topLeftRadiusChanged();
    }
}

qreal Box::topRightRadius() const
{
    return this->m_bottomRightRadius;
}

void Box::setTopRightRadius(qreal value)
{
    if (this->m_topRightRadius != value) {
        this->m_topRightRadius = value;

        emit this->topRightRadiusChanged();
    }
}

qreal Box::bottomLeftRadius() const
{
    return this->m_bottomLeftRadius;
}

void Box::setBottomLeftRadius(qreal value)
{
    if (this->m_bottomLeftRadius != value) {
        this->m_bottomLeftRadius = value;

        emit this->bottomLeftRadiusChanged();
    }
}

qreal Box::bottomRightRadius() const
{
    return this->m_bottomRightRadius;
}

void Box::setBottomRightRadius(qreal value)
{
    if (this->m_bottomRightRadius != value) {
        this->m_bottomRightRadius = value;

        emit this->bottomRightRadiusChanged();
    }
}

//===================
// Paint.
//===================
QSGNode* Box::updatePaintNode(QSGNode *oldNode, QQuickItem::UpdatePaintNodeData *)
{
    QImage canvas(View::width(), View::height(), QImage::Format_ARGB32);
    QBrush brush;

    canvas.fill(QColor("transparent"));

    QPainter painter(&canvas);
    brush.setStyle(Qt::SolidPattern);
    brush.setColor(this->color());
    painter.setPen(Qt::NoPen);
    painter.setBrush(brush);
    if (this->m_topLeftRadius + this->m_topRightRadius + this->m_bottomLeftRadius + this->m_bottomRightRadius == 0) {
        painter.drawRect(0, 0, View::width(), View::height());
    } else {
        painter.setRenderHint(QPainter::Antialiasing);

        QPainterPath path;
        path.moveTo(this->m_topLeftRadius, 0);
        // Top left radius.
        path.cubicTo(0, 0, 0, this->m_topLeftRadius, 0, this->m_topLeftRadius);
        path.lineTo(0, View::height() - this->m_bottomLeftRadius);
        // Bottom left radius.
        path.cubicTo(0, View::height(), this->m_bottomLeftRadius, View::height(), this->m_bottomLeftRadius, View::height());
        path.lineTo(View::width() - this->m_bottomRightRadius, View::height());
        // Bottom right radius.
//        path.cubicTo(200, 200, 200, 200 - 20, 200, 200 - 20);
        path.cubicTo(View::width(), View::height(), View::width(), View::height() - this->m_bottomRightRadius, View::width(), View::height() - this->m_bottomRightRadius);
        path.lineTo(View::width(), this->m_topRightRadius);
        // Top right radius.
        path.cubicTo(View::width(), 0, View::width() - this->m_topRightRadius, 0, View::width() - this->m_topRightRadius, 0);
        path.lineTo(View::width() - this->m_topLeftRadius, 0);
        painter.drawPath(path);
    }

    QSGTexture *texture = this->window()->createTextureFromImage(canvas);
    QSGSimpleTextureNode *node = static_cast<QSGSimpleTextureNode*>(oldNode);
    if (!node) {
        node = new QSGSimpleTextureNode();
    }
    node->setRect(0, 0, View::width(), View::height());
    node->setTexture(texture);

    return node;
}

} // namespace bl
