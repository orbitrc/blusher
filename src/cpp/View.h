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

protected:
    virtual void componentComplete() override;

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
    /// \brief Disconnect the connections about anchors.fill.
    void clearAnchorsFill();
    /// \brief Connect signals to slots about anchors.fill.
    void adjustAnchorsFill();
    /// \brief Disconnect the connections about anchors.centerIn.
    void clearAnchorsCenterIn();
    /// \brief Connect signals to slots about anchors.centerIn.
    void adjustAnchorsCenterIn();
    /// \brief Disconnect the connections about anchors.top and anchors.bottom.
    void clearAnchorsTopBottom();
    /// \brief Connect signals to slots about anchors.top and anchors.bottom.
    void adjustAnchorsTopBottom();
    /// \brief Disconnect the connections about anchors.left and anchors.right.
    void clearAnchorsLeftRight();
    /// \brief Connect signals to slots about anchors.left and anchors.right.
    void adjustAnchorsLeftRight();
    /// \brief Disconnect the connection about anchors.horizontalCenter.
    void clearAnchorsHorizontalCenter();
    /// \brief Connect signal to slot about anchors.horizontalCenter.
    void adjustAnchorsHorizontalCenter();
    /// \brief Disconnect the connection about anchors.verticalCenter.
    void clearAnchorsVerticalCenter();
    /// \brief Connect signal to slot about anchors.verticalCenter.
    void adjustAnchorsVerticalCenter();

private slots:
    void onWindowChanged(QQuickWindow *window);

    /// \brief Connect with QQuickItem::xChanged() signal.
    void q_onXChanged();
    /// \brief Connect with QQuickItem::yChanged() signal.
    void q_onYChanged();
    /// \brief Connect with QQuickItem::widthChanged() signal.
    void q_onWidthChanged();
    /// \brief Connect with QQuickItem::heightChanged() signal.
    void q_onHeightChanged();

private:
    bool _has_only_top_anchor();
    bool _has_only_bottom_anchor();
    bool _has_both_top_bottom_anchor();
    bool _has_only_left_anchor();
    bool _has_only_right_anchor();
    bool _has_both_left_right_anchor();

    void _set_anchors_top();
    void _set_anchors_bottom();
    void _set_anchors_top_bottom();
    void _set_anchors_left();
    void _set_anchors_right();
    void _set_anchors_left_right();
    void _set_anchors_horizontal_center();
    void _set_anchors_vertical_center();

private:
    QPointF m_pos;
    QSizeF m_size;
    bool m_scaleWidth;
    bool m_scaleHeight;
    Anchors m_anchors;
};

} // namespace bl
#endif // _BL_VIEW_H
