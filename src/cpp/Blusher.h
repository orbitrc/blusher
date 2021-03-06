#ifndef _BL_BLUSHER_H
#define _BL_BLUSHER_H

#include <QObject>

#include <QRectF>

#include "Menu.h"

class QApplication;

namespace bl {

class MenuView;

class Blusher : public QObject
{
    Q_OBJECT

public:
    enum class KeyModifier {
        None    = 0x00000000, // 00000000 00000000 00000000 00000000
        Shift   = 0x01000000, // 00000001 00000000 00000000 00000000
        Control = 0x02000000, // 00000010 00000000 00000000 00000000
        Alt     = 0x04000000, // 00000100 00000000 00000000 00000000
        Super   = 0x08000000, // 00001000 00000000 00000000 00000000
    };
    Q_ENUM(KeyModifier)

public:
    explicit Blusher(QObject *parent = nullptr);

    QApplication* app() const;
    void _set_app(QObject *app);

    static Blusher *singleton;

    Q_INVOKABLE void copyTextToClipboard(QString text);

    QRectF menuBarRect() const;
    Q_INVOKABLE void setMenuBarRect(QRectF rect);
    QRectF menuBarMenuItemRect() const;
    Q_INVOKABLE void setMenuBarMenuItemRect(QRectF rect);

    QRect submenuViewRect() const;
    void setSubmenuViewRect(const QRect& rect);

    /// \brief Append menu view to the list.
    void append_menu_view(MenuView *menu_view);
    /// \brief Pop last menu view from the list.
    MenuView* pop_menu_view();

signals:
    void appChanged();

    void menuClosed();
    void menuClosedByUser();

public slots:

private:
    QObject *p_app;

    QRectF m_menuBarRect;
    QRectF m_menuBarMenuItemRect;
    QList<MenuView*> m_menu_views;
};

#endif // _BL_BLUSHER_H

} // namespace bl
