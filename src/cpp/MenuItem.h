#ifndef _BL_MENU_ITEM_H
#define _BL_MENU_ITEM_H

#include <QObject>

namespace bl {

class MenuItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
public:
    explicit MenuItem(QObject *parent = nullptr);

    QString title() const;
    void setTitle(QString title);

signals:
    void titleChanged();

public slots:

private:
    QString m_title;
};

} // namespace bl

#endif // _BL_MENU_ITEM_H
