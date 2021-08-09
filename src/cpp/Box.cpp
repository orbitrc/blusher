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
    this->m_borderWidth = 0;
    this->m_borderColor = Qt::black;

    QObject::connect(this, &Box::widthChanged,
                     this, [this]() {
        update();
    });
    QObject::connect(this, &Box::heightChanged,
                     this, [this]() {
        update();
    });
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

qreal Box::borderWidth() const
{
    return this->m_borderWidth;
}

void Box::setBorderWidth(qreal radius)
{
    if (this->m_borderWidth != radius) {
        this->m_borderWidth = radius;

        emit this->borderWidthChanged();
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
    if (this->width() == 0 || this->height() == 0) {
        return oldNode;
    }
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
        if (this->m_borderWidth != 0) {
            QPen pen;
            pen.setWidth((this->m_borderWidth * 2) * scale);
            pen.setColor(this->m_borderColor);
            painter.setPen(pen);
        }
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
        path.cubicTo(width, height, width, height - bottom_right_radius, width, height - bottom_right_radius);
        path.lineTo(width, top_right_radius);
        // Top right radius.
        path.cubicTo(width, 0, width - top_right_radius, 0, width - top_right_radius, 0);
        path.lineTo(top_left_radius, 0);
        painter.drawPath(path);

        if (this->m_borderWidth != 0) {
            QPainterPathStroker stroker;
            stroker.setWidth((this->m_borderWidth * 2) * scale);
            QPainterPath strokedPath = stroker.createStroke(path);
            QPainterPath innerBorder = strokedPath.intersected(path);
            brush.setColor(this->m_borderColor);
            painter.setBrush(brush);
            painter.drawPath(innerBorder);
        }
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
