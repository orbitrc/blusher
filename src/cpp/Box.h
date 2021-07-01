#ifndef BOX_H
#define BOX_H

#include <QQuickPaintedItem>

#include "View.h"

namespace bl {

class Box : public View
{
    Q_OBJECT

    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged)
    Q_PROPERTY(qreal topLeftRadius READ topLeftRadius WRITE setTopLeftRadius NOTIFY topLeftRadiusChanged)
public:
    Box(QQuickItem *parent = nullptr);

    QColor color() const;
    void setColor(const QColor& color);

    qreal topLeftRadius() const;
    void setTopLeftRadius(qreal value);

protected:
    virtual QSGNode* updatePaintNode(QSGNode* oldNode, QQuickItem::UpdatePaintNodeData*);

signals:
    void colorChanged();
    void topLeftRadiusChanged();

private:
    QColor m_color;
    qreal m_topLeftRadius;
};

} // namespace bl

#endif // BOX_H
