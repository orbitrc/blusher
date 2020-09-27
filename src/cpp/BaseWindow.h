#ifndef _BL_BASE_WINDOW_H
#define _BL_BASE_WINDOW_H

#include <QQuickWindow>

#include "KeyEvent.h"

namespace bl {

class BaseWindow : public QQuickWindow
{
    Q_OBJECT

    Q_PROPERTY(QList<int> netWmStrutPartial READ netWmStrutPartial WRITE setNetWmStrutPartial NOTIFY netWmStrutPartialChanged)
    Q_PROPERTY(int netWmWindowType READ netWmWindowType WRITE setNetWmWindowType NOTIFY netWmWindowTypeChanged)
    Q_PROPERTY(bool onAllDesktops READ onAllDesktops WRITE setOnAllDesktops NOTIFY onAllDesktopsChanged)
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

    enum class NetWmWindowType {
        Desktop,
        Dock,
        Toolbar,
        Menu,
        Utility,
        Splash,
        Dialog,
        DropDownMenu,
        PopUpMenu,
        ToolTip,
        Notification,
        Combo,
        Dnd,
        Normal,
    };
    Q_ENUM(NetWmWindowType)

public:
    explicit BaseWindow(QWindow *parent = nullptr);

    QList<int> netWmStrutPartial() const;
    void setNetWmStrutPartial(QList<int> value);

    int netWmWindowType() const;
    void setNetWmWindowType(int type);

    bool onAllDesktops() const;
    void setOnAllDesktops(bool value);

    int type() const;
    void setType(int type);

    qreal screenScale() const;
    QString screenName() const;

protected:
    bool event(QEvent *) override;
    void keyPressEvent(QKeyEvent *) override;
    void showEvent(QShowEvent *) override;

signals:
    void netWmStrutPartialChanged(QList<int> strut);
    void netWmWindowTypeChanged();
    void onAllDesktopsChanged(bool value);
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
    QList<int> m_netWmStrutPartial;
    int m_netWmWindowType;
    int m_type;
    qreal m_scale;
};

} // namespace bl

#endif // _BL_BASE_WINDOW_H
