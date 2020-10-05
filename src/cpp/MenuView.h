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

    bool isMenuBarMenu() const;
    void setMenuBarMenu(bool value);

    QRectF menuBarRect() const;
    void setMenuBarRect(QRectF rect);

protected:
    void keyPressEvent(QKeyEvent *) override;
    void mouseMoveEvent(QMouseEvent *) override;
    void mousePressEvent(QMouseEvent *) override;
    virtual void paintEvent(QPaintEvent *event) override;

signals:
    void closed();
    void closedByUser();

private:
    bool m_menuBarMenu;
    QRectF m_menuBarRect;

    bool m_mouseGrabEnabled;

    Menu *m_menu;
};

} // namespace bl

#endif // _BL_MENU_VIEW_H
