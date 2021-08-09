#ifndef _BL_BASE_WINDOW_H
#define _BL_BASE_WINDOW_H

#include <QQuickWindow>

#include "Anchors.h"
#include "KeyEvent.h"
#include "Menu.h"

namespace bl {

class BaseWindow : public QQuickWindow
{
    Q_OBJECT

    Q_PROPERTY(QList<int> netWmStrutPartial READ netWmStrutPartial WRITE setNetWmStrutPartial NOTIFY netWmStrutPartialChanged)
    Q_PROPERTY(int netWmWindowType READ netWmWindowType WRITE setNetWmWindowType NOTIFY netWmWindowTypeChanged)
    Q_PROPERTY(bool onAllDesktops READ onAllDesktops WRITE setOnAllDesktops NOTIFY onAllDesktopsChanged)
    Q_PROPERTY(int transientFor READ transientFor WRITE setTransientFor NOTIFY transientForChanged)
    Q_PROPERTY(int type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(int x READ x WRITE setX NOTIFY xChanged)
    Q_PROPERTY(int y READ y WRITE setY NOTIFY yChanged)
    Q_PROPERTY(int width READ width WRITE setWidth NOTIFY widthChanged)
    Q_PROPERTY(int height READ height WRITE setHeight NOTIFY heightChanged)
    Q_PROPERTY(Menu* menu READ menu WRITE setMenu NOTIFY menuChanged)
    Q_PROPERTY(qreal screenScale READ screenScale NOTIFY screenScaleChanged)
    Q_PROPERTY(QString screenName READ screenName NOTIFY screenNameChanged)
    Q_PROPERTY(int windowId READ windowId CONSTANT)
    Q_PROPERTY(AnchorLine top READ top CONSTANT)
    Q_PROPERTY(AnchorLine bottom READ bottom CONSTANT)
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

    int transientFor() const;
    void setTransientFor(int win);

    int type() const;
    void setType(int type);

    int x() const;
    void setX(int x);

    int y() const;
    void setY(int y);

    int width() const;
    void setWidth(int width);

    int height() const;
    void setHeight(int height);

    Menu* menu() const;
    void setMenu(Menu* menu);

    qreal screenScale() const;
    QString screenName() const;

    int windowId() const;

    AnchorLine top();
    AnchorLine bottom();

protected:
    bool event(QEvent *) override;
    void keyPressEvent(QKeyEvent *) override;
    void showEvent(QShowEvent *) override;

signals:
    void netWmStrutPartialChanged(QList<int> strut);
    void netWmWindowTypeChanged();
    void onAllDesktopsChanged(bool value);
    void transientForChanged(int windowId);
    void typeChanged();
    void xChanged(int x);
    void yChanged(int y);
    void widthChanged(int width);
    void heightChanged(int height);
    void menuChanged();
    void screenScaleChanged(qreal scale);
    void screenNameChanged();

    void keyPressed(KeyEvent *event);

public slots:
    void changeScale();

private slots:
    /// \brief Connect with &QQuickWindow::screenChanged() signal.
    void q_onScreenChanged(QScreen *qscreen);
    /// \brief Connect with QWindow::xChanged() signal.
    void q_onXChanged(int x);
    /// \brief Connect with QWindow::yChanged() signal.
    void q_onYChanged(int y);
    /// \brief Connect with QWindow::widthChanged() signal.
    void q_onWidthChanged(int width);
    /// \brief Connect with QWindow::heightChanged() signal.
    void q_onHeightChanged(int height);
    void onScreensChanged();

private:
    QList<int> m_netWmStrutPartial;
    int m_netWmWindowType;
    int m_transientFor;
    int m_type;
    QPoint m_pos;
    QSize m_size;
    qreal m_scale;
    Menu *m_menu;
    Anchors m_anchors;
};

} // namespace bl

#endif // _BL_BASE_WINDOW_H
