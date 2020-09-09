#include "DesktopEnvironment.h"

#include <QApplication>
#include <QScreen>
// Debug
#include <QDebug>

#include "Blusher.h"

namespace bl {

DesktopEnvironment *DesktopEnvironment::singleton = nullptr;

DesktopEnvironment::DesktopEnvironment(QObject *parent)
    : QObject(parent)
{
    QApplication *app = Blusher::singleton->app();
    auto screens = app->screens();
    for (int i = 0; i < screens.length(); ++i) {
        QScreen *scr = screens[i];
        QString name = scr->name();

        QVariantMap screen_info;
        screen_info["pixelsPerDp"] = 1;
        this->m_screens[name] = screen_info;
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
