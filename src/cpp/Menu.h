#ifndef _BL_MENU_H
#define _BL_MENU_H

#include <QObject>

#include <QQmlListProperty>

namespace bl {

class Menu : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QQmlListProperty<QObject> items READ items)
    Q_CLASSINFO("DefaultProperty", "items")
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

    QQmlListProperty<QObject> items();
    QList<QObject*> items_data();

    Q_INVOKABLE void addItem(QObject *item);
    Q_INVOKABLE void open();

signals:
    void typeChanged();
    void titleChanged();

public slots:

private:
    int m_type;
    QString m_title;
    QList<QObject*> m_items;
};

} // namespace bl

#endif // _BL_MENU_H
