#ifndef _BL_BASE_WINDOW_H
#define _BL_BASE_WINDOW_H

#include <QQuickWindow>

class BaseWindow : public QQuickWindow
{
    Q_OBJECT

    Q_PROPERTY(int type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(qreal pixelsPerDp READ pixelsPerDp NOTIFY pixelsPerDpChanged)
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

signals:
    void typeChanged();
    void pixelsPerDpChanged();

public slots:

private slots:
    void q_onScreenChanged();
    void onScreensChanged();

private:
    int m_type;
    qreal m_pixelsPerDp;
};

#endif // _BL_BASE_WINDOW_H
