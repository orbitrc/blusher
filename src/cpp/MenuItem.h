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
    Q_PROPERTY(bool separator READ separator WRITE setSeparator NOTIFY separatorChanged)
    Q_PROPERTY(QObject* submenu READ submenu WRITE setSubmenu NOTIFY submenuChanged)
    Q_PROPERTY(QObject* parentMenu READ parentMenu WRITE setParentMenu NOTIFY parentMenuChanged)
    Q_PROPERTY(int shortcut READ shortcut WRITE setShortcut NOTIFY shortcutChanged)
    Q_PROPERTY(bool checked READ checked WRITE setChecked NOTIFY checkedChanged)
    Q_INTERFACES(QQmlParserStatus)
public:
    explicit MenuItem(QObject *parent = nullptr);

    //=========================
    // Property getter/setter
    //=========================
    QString title() const;
    void setTitle(QString title);

    bool separator() const;
    void setSeparator(bool value);

    QObject* submenu() const;
    void setSubmenu(QObject *submenu);

    QObject* parentMenu() const;
    void setParentMenu(QObject *menu);

    int shortcut() const;
    void setShortcut(int shortcut);

    bool checked() const;
    void setChecked(bool value);


    Q_INVOKABLE bool isMenuBarMenuItem() const;


    //===================
    // QQmlParserStatus
    //===================
    virtual void classBegin() override;
    virtual void componentComplete() override;

signals:
    void titleChanged();
    void separatorChanged();
    void submenuChanged();
    void parentMenuChanged();
    void shortcutChanged();
    void checkedChanged();

    void triggered();

public slots:

private:
    QString m_title;
    bool m_separator;
    QObject *m_submenu;
    QObject *m_parentMenu;
    int m_shortcut;
    bool m_checked;
};

} // namespace bl

#endif // _BL_MENU_ITEM_H
