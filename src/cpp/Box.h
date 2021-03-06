#ifndef _BL_BOX_H
#define _BL_BOX_H

#include <QQuickPaintedItem>

#include "View.h"

namespace bl {

class Box : public View
{
    Q_OBJECT

    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged)
    Q_PROPERTY(qreal radius READ radius WRITE setRadius NOTIFY radiusChanged)
    Q_PROPERTY(qreal topLeftRadius READ topLeftRadius WRITE setTopLeftRadius NOTIFY topLeftRadiusChanged)
    Q_PROPERTY(qreal topRightRadius READ topRightRadius WRITE setTopRightRadius NOTIFY topRightRadiusChanged)
    Q_PROPERTY(qreal bottomLeftRadius READ bottomLeftRadius WRITE setBottomLeftRadius NOTIFY bottomLeftRadiusChanged)
    Q_PROPERTY(qreal bottomRightRadius READ bottomRightRadius WRITE setBottomRightRadius NOTIFY bottomRightRadiusChanged)
    Q_PROPERTY(qreal borderWidth READ borderWidth WRITE setBorderWidth NOTIFY borderWidthChanged)
    Q_PROPERTY(QColor borderColor READ borderColor WRITE setBorderColor NOTIFY borderColorChanged)
public:
    Box(QQuickItem *parent = nullptr);

    QColor color() const;
    void setColor(const QColor& color);

    qreal radius() const;
    void setRadius(qreal val);

    qreal topLeftRadius() const;
    void setTopLeftRadius(qreal value);

    qreal topRightRadius() const;
    void setTopRightRadius(qreal value);

    qreal bottomLeftRadius() const;
    void setBottomLeftRadius(qreal value);

    qreal bottomRightRadius() const;
    void setBottomRightRadius(qreal value);

    qreal borderWidth() const;
    void setBorderWidth(qreal width);

    QColor borderColor() const;
    void setBorderColor(const QColor& color);

protected:
    virtual QSGNode* updatePaintNode(QSGNode* oldNode, QQuickItem::UpdatePaintNodeData*);

signals:
    void colorChanged();
    void radiusChanged();
    void topLeftRadiusChanged();
    void topRightRadiusChanged();
    void bottomLeftRadiusChanged();
    void bottomRightRadiusChanged();
    void borderWidthChanged();
    void borderColorChanged();

private:
    QColor m_color;
    qreal m_radius;
    qreal m_topLeftRadius;
    qreal m_topRightRadius;
    qreal m_bottomLeftRadius;
    qreal m_bottomRightRadius;
    qreal m_borderWidth;
    QColor m_borderColor;
};

} // namespace bl

#endif // _BL_BOX_H
