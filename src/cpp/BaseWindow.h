#ifndef _BL_BASE_WINDOW_H
#define _BL_BASE_WINDOW_H

#include <QQuickWindow>

#include "KeyEvent.h"

class BaseWindow : public QQuickWindow
{
    Q_OBJECT

    Q_PROPERTY(int type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(qreal pixelsPerDp READ pixelsPerDp NOTIFY pixelsPerDpChanged)
    Q_PROPERTY(QString screenName READ screenName NOTIFY screenNameChanged)
public:
    enum class WindowType {
        DocumentWindow,
        AppWindow,
        Panel,
        Dialog,
        Alert,
        Menu,
    };
    Q_ENUM(WindowType)

public:
    explicit BaseWindow(QWindow *parent = nullptr);

    int type() const;
    void setType(int type);
    qreal pixelsPerDp() const;
    QString screenName() const;

protected:
    bool event(QEvent *) override;
    void keyPressEvent(QKeyEvent *) override;

signals:
    void typeChanged();
    void pixelsPerDpChanged();
    void screenNameChanged();

    void keyPressed(bl::KeyEvent *event);

public slots:

private slots:
    void q_onScreenChanged(QScreen *qscreen);
    void onScreensChanged();

private:
    int m_type;
    qreal m_pixelsPerDp;
};

#endif // _BL_BASE_WINDOW_H
