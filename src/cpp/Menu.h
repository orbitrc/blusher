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
    Q_PROPERTY(QQmlListProperty<bl::MenuItem> items READ items)
    Q_PROPERTY(Menu* supermenu READ supermenu WRITE setSupermenu NOTIFY supermenuChanged)
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
    MenuView* to_qmenu();

    Q_INVOKABLE void addItem(MenuItem *item);
    Q_INVOKABLE void open(double x = 0, double y = 0);

    virtual void classBegin() override;
    virtual void componentComplete() override;

signals:
    void typeChanged();
    void titleChanged();
    void supermenuChanged();

public slots:

private:
    int m_type;
    QString m_title;
    QList<MenuItem*> m_items;
    Menu *m_supermenu;
};

} // namespace bl

#endif // _BL_MENU_H
