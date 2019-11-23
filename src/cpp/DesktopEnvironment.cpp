#include "DesktopEnvironment.h"

#include <blusher/Application.h>

#include <QScreen>
// Debug
#include <QDebug>

namespace bl {

DesktopEnvironment *DesktopEnvironment::singleton = nullptr;

DesktopEnvironment::DesktopEnvironment(QObject *parent)
    : QObject(parent)
{
    Application *app = qobject_cast<Application*>(Application::instance());
    auto screens = app->screens();
    for (int i = 0; i < screens.length(); ++i) {
        QScreen *scr = screens[i];
        QString name = scr->name();
        this->m_screens[name] = QVariantMap();
        this->m_screens[name].toMap()["pixelsPerDp"] = 1;
    }

    QObject::connect(this, &DesktopEnvironment::screenInfoChanged,
                     this, &DesktopEnvironment::onScreenInfoChanged);
}

QVariantMap DesktopEnvironment::screens() const
{
    return this->m_screens;
}


void DesktopEnvironment::onScreenInfoChanged(QString name, QString key, QVariant value)
{
    qDebug() << name << key << value;
}

} // namespace bl
