#ifndef _BL_MENU_H
#define _BL_MENU_H

#include <QObject>
#include <QQmlParserStatus>

#include <QQmlListProperty>

#include "MenuItem.h"

namespace bl {

class MenuView;

class Menu : public QObject, public QQmlParserStatus
{
    Q_OBJECT
    Q_PROPERTY(int type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QQmlListProperty<bl::MenuItem> items READ items NOTIFY itemsChanged)
    Q_PROPERTY(bool opened READ opened NOTIFY openedChanged)
    Q_PROPERTY(Menu* supermenu READ supermenu WRITE setSupermenu NOTIFY supermenuChanged)
    Q_PROPERTY(int activeIndex READ activeIndex WRITE setActiveIndex NOTIFY activeIndexChanged)
    Q_CLASSINFO("DefaultProperty", "items")
    Q_INTERFACES(QQmlParserStatus)
public:
    enum class MenuType {
        MenuBarMenu = 0,
        ContextualMenu = 1,
        Submenu = 2
    };
    Q_ENUM(MenuType)

    explicit Menu(QObject *parent = nullptr);

    int type() const;
    void setType(int type);

    QString title() const;
    void setTitle(QString title);

    Menu* supermenu() const;
    void setSupermenu(Menu *supermenu);

    QQmlListProperty<MenuItem> items();
    QList<MenuItem*> itemsData() const;

    bool opened() const;

    int activeIndex() const;
    void setActiveIndex(int index);

    MenuView* menuView();
    void setMenuView(MenuView *menuView);

    Q_INVOKABLE void addItem(MenuItem *item);
    Q_INVOKABLE void open(double x = 0, double y = 0);
    Q_INVOKABLE void close();

    virtual void classBegin() override;
    virtual void componentComplete() override;

signals:
    //===========================
    // Property change signals
    //===========================
    void itemsChanged();
    void openedChanged(bool value);
    void typeChanged();
    void titleChanged();
    void supermenuChanged();
    void activeIndexChanged(int index);

    //========================
    // Other signals
    //========================
    void closing();

public slots:

private:
    int m_type;
    QString m_title;
    QList<MenuItem*> m_items;
    bool m_opened;
    Menu *m_supermenu;
    int m_activeIndex;

    MenuView *m_menuView;
    QObject *m_menuWindow;
};

} // namespace bl

#endif // _BL_MENU_H
