#ifndef _BL_WINDOW_H
#define _BL_WINDOW_H

#include <QQuickWindow>

class Window : public QQuickWindow
{
    Q_OBJECT

    Q_PROPERTY(qreal pixelsPerDp READ pixelsPerDp NOTIFY pixelsPerDpChanged)
public:
    explicit Window(QWindow *parent = nullptr);

    qreal pixelsPerDp() const;

signals:
    void pixelsPerDpChanged();

public slots:

private slots:
    void q_onScreenChanged();
    void onScreensChanged();

private:
    qreal m_pixelsPerDp;
};

#endif // _BL_WINDOW_H
