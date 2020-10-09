#ifndef _BL_MENU_VIEW_H
#define _BL_MENU_VIEW_H

#include <QQuickWidget>

namespace bl {

class Menu;

class MenuView : public QQuickWidget
{
    Q_OBJECT
public:
    MenuView(Menu *menu, QWidget *parent = nullptr);
    ~MenuView();

    Menu* menu();

    bool isMenuBarMenu() const;
    void setMenuBarMenu(bool value);

    QRectF menuBarRect() const;
    void setMenuBarRect(QRectF rect);

    bool mouseGrabEnabled() const;
    void setMouseGrabEnabled(bool value);

    bool is_menu_bar_child() const;
    bool is_top_level_menu_view() const;
    MenuView* submenu_view();
    void set_submenu_view(MenuView *menu_view);

protected:
    virtual void keyPressEvent(QKeyEvent *) override;
    virtual void mouseMoveEvent(QMouseEvent *) override;
    virtual void mousePressEvent(QMouseEvent *) override;
    virtual void paintEvent(QPaintEvent *event) override;

signals:
    void closed();
    void closedByUser();
    void aboutToCloseByUser();

private slots:
    void onMenuEntered();
    void onMenuLeaved();

private:
    bool m_menuBarMenu;
    QRectF m_menuBarRect;
    MenuView *m_submenu_view;

    bool m_mouseGrabEnabled;

    Menu *m_menu;
};

} // namespace bl

#endif // _BL_MENU_VIEW_H
