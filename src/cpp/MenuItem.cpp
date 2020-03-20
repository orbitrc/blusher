#include "MenuItem.h"

#include <QAction>

namespace bl {

MenuItem::MenuItem(QObject *parent)
    : QObject(parent)
{

}

QString MenuItem::title() const
{
    return this->m_title;
}

void MenuItem::setTitle(QString title)
{
    if (this->m_title != title) {
        this->m_title = title;

        emit this->titleChanged();
    }
}

QAction* MenuItem::to_qaction()
{
    QAction *qaction = new QAction;
    qaction->setText(this->title());
    QObject::connect(qaction, &QAction::triggered,
                     this, &MenuItem::triggered);

    return qaction;
}

} // namespace bl
