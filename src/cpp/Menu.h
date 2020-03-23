#ifndef _BL_MENU_H
#define _BL_MENU_H

#include <QObject>
#include <QQmlParserStatus>

#include <QQmlListProperty>

namespace bl {

class MenuView;

class Menu : public QObject, public QQmlParserStatus
{
    Q_OBJECT
    Q_PROPERTY(int type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QQmlListProperty<QObject> items READ items)
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

    QQmlListProperty<QObject> items();
    QList<QObject*> items_data();
    MenuView* to_qmenu();

    Q_INVOKABLE void addItem(QObject *item);
    Q_INVOKABLE void open(double x = 0, double y = 0);

    virtual void classBegin() override;
    virtual void componentComplete() override;

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