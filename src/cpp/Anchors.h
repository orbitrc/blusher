#ifndef _BL_ANCHORS_H
#define _BL_ANCHORS_H

#include <QObject>
#include <QQuickItem>

namespace bl {

class View;

class AnchorLine : public QMetaObject {
public:
    enum class Anchor {
        None,
        TopAnchor,
        LeftAnchor,
        RightAnchor,
        BottomAnchor,
        HorizontalCenterAnchor,
        VerticalCenterAnchor,
    };
public:
    AnchorLine(QQuickItem *view = nullptr, Anchor anchor = Anchor::None);

    void setView(QQuickItem *view);

    QQuickItem *view = nullptr;
    Anchor anchor;
};

class Anchors : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQuickItem* fill READ fill WRITE setFill NOTIFY fillChanged)
    Q_PROPERTY(QQuickItem* centerIn READ centerIn WRITE setCenterIn NOTIFY centerInChanged)
    Q_PROPERTY(AnchorLine top READ top WRITE setTop NOTIFY topChanged)
    Q_PROPERTY(AnchorLine left READ left WRITE setLeft NOTIFY leftChanged)
    Q_PROPERTY(AnchorLine right READ right WRITE setRight NOTIFY rightChanged)
    Q_PROPERTY(AnchorLine bottom READ bottom WRITE setBottom NOTIFY bottomChanged)
    Q_PROPERTY(AnchorLine horizontalCenter READ horizontalCenter WRITE setHorizontalCenter NOTIFY horizontalCenterChanged)
    Q_PROPERTY(AnchorLine verticalCenter READ verticalCenter WRITE setVerticalCenter NOTIFY verticalCenterChanged)
    Q_PROPERTY(qreal topMargin READ topMargin WRITE setTopMargin NOTIFY topMarginChanged)
    Q_PROPERTY(qreal leftMargin READ leftMargin WRITE setLeftMargin NOTIFY leftMarginChanged)
    Q_PROPERTY(qreal rightMargin READ rightMargin WRITE setRightMargin NOTIFY rightMarginChanged)
    Q_PROPERTY(qreal bottomMargin READ bottomMargin WRITE setBottomMargin NOTIFY bottomMarginChanged)
public:
    Anchors(QObject *parent = nullptr);

    QQuickItem* fill() const;
    void setFill(QQuickItem *view);

    QQuickItem* centerIn() const;
    void setCenterIn(QQuickItem *view);

    QQuickItem* topAnchorView();
    QQuickItem* leftAnchorView();
    QQuickItem* rightAnchorView();
    QQuickItem* bottomAnchorView();
    QQuickItem* horizontalCenterAnchorView();
    QQuickItem* verticalCenterAnchorView();

    AnchorLine::Anchor topAnchor() const;
    AnchorLine::Anchor leftAnchor() const;
    AnchorLine::Anchor rightAnchor() const;
    AnchorLine::Anchor bottomAnchor() const;
    AnchorLine::Anchor horizontalCenterAnchor() const;
    AnchorLine::Anchor verticalCenterAnchor() const;

    AnchorLine top();
    void setTop(const AnchorLine& top);

    AnchorLine left();
    void setLeft(const AnchorLine& left);

    AnchorLine right();
    void setRight(const AnchorLine& right);

    AnchorLine bottom();
    void setBottom(const AnchorLine& bottom);

    AnchorLine horizontalCenter();
    void setHorizontalCenter(const AnchorLine& hCenter);

    AnchorLine verticalCenter();
    void setVerticalCenter(const AnchorLine& vCenter);

    qreal topMargin() const;
    void setTopMargin(qreal topMargin);

    qreal leftMargin() const;
    void setLeftMargin(qreal leftMargin);

    qreal rightMargin() const;
    void setRightMargin(qreal rightMargin);

    qreal bottomMargin() const;
    void setBottomMargin(qreal bottomMargin);

signals:
    void fillChanged();
    void centerInChanged();
    void topChanged();
    void leftChanged();
    void rightChanged();
    void bottomChanged();
    void horizontalCenterChanged();
    void verticalCenterChanged();
    void topMarginChanged(qreal topMargin);
    void leftMarginChanged(qreal leftMargin);
    void rightMarginChanged(qreal rightMargin);
    void bottomMarginChanged(qreal bottomMargin);

private:
    QQuickItem *m_fill;
    QQuickItem *m_centerIn;
    QQuickItem *m_topAnchorView;
    QQuickItem *m_leftAnchorView;
    QQuickItem *m_rightAnchorView;
    QQuickItem *m_bottomAnchorView;
    QQuickItem *m_horizontalCenterAnchorView;
    QQuickItem *m_verticalCenterAnchorView;
    AnchorLine::Anchor m_topAnchor;
    AnchorLine::Anchor m_leftAnchor;
    AnchorLine::Anchor m_rightAnchor;
    AnchorLine::Anchor m_bottomAnchor;
    AnchorLine::Anchor m_horizontalCenterAnchor;
    AnchorLine::Anchor m_verticalCenterAnchor;
    AnchorLine m_top;
    AnchorLine m_left;
    AnchorLine m_right;
    AnchorLine m_bottom;
    AnchorLine m_horizontalCenter;
    AnchorLine m_verticalCenter;
    qreal m_topMargin;
    qreal m_leftMargin;
    qreal m_rightMargin;
    qreal m_bottomMargin;
};

} // namespace bl

#endif // _BL_ANCHORS_H
