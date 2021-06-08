#ifndef _BL_VIEW_H
#define _BL_VIEW_H

#include <QQuickItem>
#include <QQuickPaintedItem>

#include "BaseWindow.h"

namespace bl {

class View : public QQuickItem
{
    Q_OBJECT

    Q_PROPERTY(qreal x READ x WRITE setX NOTIFY xChanged)
    Q_PROPERTY(qreal y READ y WRITE setY NOTIFY yChanged)
    Q_PROPERTY(qreal width READ width WRITE setWidth NOTIFY widthChanged)
    Q_PROPERTY(qreal height READ height WRITE setHeight NOTIFY heightChanged)
    Q_PROPERTY(bool scaleWidth READ scaleWidth WRITE setScaleWidth NOTIFY scaleWidthChanged)
    Q_PROPERTY(bool scaleHeight READ scaleHeight WRITE setScaleHeight NOTIFY scaleHeightChanged)
    Q_PROPERTY(BaseWindow* window READ window CONSTANT)
public:
    View(QQuickItem *parent = nullptr);

    qreal x() const;
    void setX(qreal x);

    qreal y() const;
    void setY(qreal y);

    qreal width() const;
    void setWidth(qreal width);

    qreal height() const;
    void setHeight(qreal height);

    bool scaleWidth() const;
    void setScaleWidth(bool val);

    bool scaleHeight() const;
    void setScaleHeight(bool val);

    BaseWindow* window() const;

signals:
    void xChanged();
    void yChanged();
    void widthChanged();
    void heightChanged();
    void scaleWidthChanged();
    void scaleHeightChanged();

public slots:
    void scale(qreal multiple);

private slots:
    void onWindowChanged(QQuickWindow *window);

private:
    QPointF m_pos;
    QSizeF m_size;
    bool m_scaleWidth;
    bool m_scaleHeight;
};

} // namespace bl
#endif // _BL_VIEW_H
