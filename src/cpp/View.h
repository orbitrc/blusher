#ifndef _BL_VIEW_H
#define _BL_VIEW_H

#include <QQuickItem>
#include <QQuickPaintedItem>

#include "BaseWindow.h"
#include "Anchors.h"

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
    Q_PROPERTY(Anchors* anchors READ anchors CONSTANT)
    Q_PROPERTY(AnchorLine top READ top CONSTANT)
    Q_PROPERTY(AnchorLine left READ left CONSTANT)
    Q_PROPERTY(AnchorLine right READ right CONSTANT)
    Q_PROPERTY(AnchorLine bottom READ bottom CONSTANT)
    Q_PROPERTY(AnchorLine horizontalCenter READ horizontalCenter CONSTANT)
    Q_PROPERTY(AnchorLine verticalCenter READ verticalCenter CONSTANT)
public:
    class Impl;
    Impl *pImpl;
public:
    View(QQuickItem *parent = nullptr);
    ~View();

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

    Anchors* anchors();

    AnchorLine top();
    AnchorLine left();
    AnchorLine right();
    AnchorLine bottom();
    AnchorLine horizontalCenter();
    AnchorLine verticalCenter();

signals:
    void xChanged();
    void yChanged();
    void widthChanged();
    void heightChanged();
    void scaleWidthChanged();
    void scaleHeightChanged();
    void anchorsChanged();

public slots:
    void scale(qreal multiple);
    void adjustAnchors();
    void clearAnchorsFill();
    void adjustAnchorsFill();

private slots:
    void onWindowChanged(QQuickWindow *window);

private:
    QPointF m_pos;
    QSizeF m_size;
    bool m_scaleWidth;
    bool m_scaleHeight;
    Anchors m_anchors;
    AnchorLine m_top;
    AnchorLine m_left;
    AnchorLine m_right;
    AnchorLine m_bottom;
    AnchorLine m_horizontalCenter;
    AnchorLine m_verticalCenter;
};

} // namespace bl
#endif // _BL_VIEW_H
