#ifndef _BL_BASE_WINDOW_H
#define _BL_BASE_WINDOW_H

#include <QQuickWindow>

#include "KeyEvent.h"

namespace bl {

class BaseWindow : public QQuickWindow
{
    Q_OBJECT

    Q_PROPERTY(int type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(qreal screenScale READ screenScale NOTIFY screenScaleChanged)
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
    qreal screenScale() const;
    QString screenName() const;

protected:
    bool event(QEvent *) override;
    void keyPressEvent(QKeyEvent *) override;

signals:
    void typeChanged();
    void screenScaleChanged(qreal scale);
    void screenNameChanged();

    void keyPressed(KeyEvent *event);

public slots:
    void changeScale();

private slots:
    void q_onScreenChanged(QScreen *qscreen);
    void onScreensChanged();

private:
    int m_type;
    qreal m_scale;
};

} // namespace bl

#endif // _BL_BASE_WINDOW_H
