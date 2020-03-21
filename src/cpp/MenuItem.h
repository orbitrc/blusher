#ifndef _BL_MENU_ITEM_H
#define _BL_MENU_ITEM_H

#include <QObject>
#include <QQmlParserStatus>

class QAction;

namespace bl {

class MenuItem : public QObject, public QQmlParserStatus
{
    Q_OBJECT
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QObject* submenu READ submenu WRITE setSubmenu NOTIFY submenuChanged)
    Q_PROPERTY(QObject* parentMenu READ parentMenu WRITE setParentMenu NOTIFY parentMenuChanged)
    Q_INTERFACES(QQmlParserStatus)
public:
    explicit MenuItem(QObject *parent = nullptr);

    QString title() const;
    void setTitle(QString title);

    QObject* submenu() const;
    void setSubmenu(QObject *submenu);

    QObject* parentMenu() const;
    void setParentMenu(QObject *menu);

    QAction* to_qaction();

    virtual void classBegin() override;
    virtual void componentComplete() override;

signals:
    void titleChanged();
    void submenuChanged();
    void parentMenuChanged();

    void triggered();

public slots:

private:
    QString m_title;
    QObject *m_submenu;
    QObject *m_parentMenu;
};

} // namespace bl

#endif // _BL_MENU_ITEM_H
