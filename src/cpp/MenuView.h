#ifndef _BL_MENU_VIEW_H
#define _BL_MENU_VIEW_H

#include <QMenu>

namespace bl {

class MenuView : public QMenu
{
    Q_OBJECT
public:
    MenuView(QWidget *parent = nullptr);

    bool isMenuBarMenu() const;
    void setMenuBarMenu(bool value);

    QRectF menuBarRect() const;
    void setMenuBarRect(QRectF rect);

protected:
    void keyPressEvent(QKeyEvent *) override;
    void mouseMoveEvent(QMouseEvent *) override;

signals:
    void closed();
    void closedByUser();

private:
    bool m_menuBarMenu;
    QRectF m_menuBarRect;
};

} // namespace bl

#endif // _BL_MENU_VIEW_H