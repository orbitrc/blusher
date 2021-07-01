#include "Box.h"

#include <QPainter>
#include <QSGSimpleTextureNode>

namespace bl {

Box::Box(QQuickItem *parent)
    : View(parent)
{
    setFlag(QQuickItem::ItemHasContents);

    this->m_color = Qt::white;
    this->m_topLeftRadius = 0;
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
    painter.drawRect(0, 0, View::width(), View::height());

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
