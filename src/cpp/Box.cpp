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
    this->m_radius = 0;
    this->m_topLeftRadius = 0;
    this->m_topRightRadius = 0;
    this->m_bottomLeftRadius = 0;
    this->m_bottomRightRadius = 0;
    this->m_borderRadius = 0;
    this->m_borderColor = Qt::black;
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

qreal Box::radius() const
{
    return this->m_radius;
}

void Box::setRadius(qreal val)
{
    if (this->m_radius != val) {
        this->m_radius = val;

        emit this->radiusChanged();
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

qreal Box::borderRadius() const
{
    return this->m_borderRadius;
}

void Box::setBorderRadius(qreal radius)
{
    if (this->m_borderRadius != radius) {
        this->m_borderRadius = radius;

        emit this->borderRadiusChanged();
    }
}

QColor Box::borderColor() const
{
    return this->m_borderColor;
}

void Box::setBorderColor(const QColor &color)
{
    if (this->m_borderColor != color) {
        this->m_borderColor = color;

        emit this->borderColorChanged();
    }
}

//===================
// Paint.
//===================
QSGNode* Box::updatePaintNode(QSGNode *oldNode, QQuickItem::UpdatePaintNodeData *)
{
    qreal scale = ((this->window() != nullptr) ? this->window()->screenScale() : 1);
    qreal width_scale = (this->scaleWidth())
        ? ((this->window() != nullptr) ? this->window()->screenScale() : 1)
        : 1;
    qreal height_scale = (this->scaleHeight())
        ? ((this->window() != nullptr) ? this->window()->screenScale() : 1)
        : 1;
    qreal width = View::width() * width_scale;
    qreal height = View::height() * height_scale;
    qreal top_left_radius = this->m_topLeftRadius * scale;
    qreal top_right_radius = this->m_topRightRadius * scale;
    qreal bottom_left_radius = this->m_bottomLeftRadius * scale;
    qreal bottom_right_radius = this->m_bottomRightRadius * scale;

    QImage canvas(width, height, QImage::Format_ARGB32);
    QBrush brush;

    canvas.fill(QColor("transparent"));

    QPainter painter(&canvas);
    brush.setStyle(Qt::SolidPattern);
    brush.setColor(this->color());
    painter.setPen(Qt::NoPen);
    painter.setBrush(brush);
    if (this->m_radius + this->m_topLeftRadius + this->m_topRightRadius + this->m_bottomLeftRadius + this->m_bottomRightRadius == 0) {
        painter.drawRect(0, 0, width, height);
    } else {
        // Set all corners radius as radius.
        if (this->m_radius != 0) {
            top_left_radius = this->m_radius;
            top_right_radius = this->m_radius;
            bottom_left_radius = this->m_radius;
            bottom_right_radius = this->m_radius;
        }
        painter.setRenderHint(QPainter::Antialiasing);

        QPainterPath path;
        path.moveTo(top_left_radius, 0);
        // Top left radius.
        path.cubicTo(0, 0, 0, top_left_radius, 0, top_left_radius);
        path.lineTo(0, height - bottom_left_radius);
        // Bottom left radius.
        path.cubicTo(0, height, bottom_left_radius, height, bottom_left_radius, height);
        path.lineTo(width - bottom_right_radius, height);
        // Bottom right radius.
//        path.cubicTo(200, 200, 200, 200 - 20, 200, 200 - 20);
        path.cubicTo(width, height, width, height - bottom_right_radius, width, height - bottom_right_radius);
        path.lineTo(width, top_right_radius);
        // Top right radius.
        path.cubicTo(width, 0, width - top_right_radius, 0, width - top_right_radius, 0);
        path.lineTo(width - top_left_radius, 0);
        painter.drawPath(path);
    }

    QSGTexture *texture = this->window()->createTextureFromImage(canvas);
    QSGSimpleTextureNode *node = static_cast<QSGSimpleTextureNode*>(oldNode);
    if (!node) {
        node = new QSGSimpleTextureNode();
    }
    node->setRect(0, 0, width, height);
    node->setTexture(texture);

    return node;
}

} // namespace bl
