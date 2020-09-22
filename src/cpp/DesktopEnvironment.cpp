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
        screen_info["scale"] = 1;
        screen_info["width"] = scr->geometry().width();
        screen_info["height"] = scr->geometry().height();
        this->m_screens[name] = screen_info;
    }

    QObject::connect(app, &QApplication::primaryScreenChanged,
                     this, &DesktopEnvironment::primaryScreenChanged);

    QObject::connect(this, &DesktopEnvironment::screenInfoChanged,
                     this, &DesktopEnvironment::onScreenInfoChanged);
}

QVariantMap DesktopEnvironment::screens() const
{
    return this->m_screens;
}

QVariantMap DesktopEnvironment::primaryScreen() const
{
    QApplication *app = Blusher::singleton->app();
    auto primary_screen = app->primaryScreen();
    QVariantMap primary_screen_info;
    primary_screen_info["name"] = primary_screen->name();
    primary_screen_info["x"] = primary_screen->geometry().x();
    primary_screen_info["y"] = primary_screen->geometry().y();

    return primary_screen_info;
}

//======================
// Q_INVOKABLE methods
//======================
void DesktopEnvironment::changeScale(const QString &name, qreal scale)
{
    auto map = this->m_screens[name].toMap();
    map["scale"] = scale;
    this->m_screens[name].setValue(map);

    emit this->screensChanged();
}

//=====================
// Private slots
//=====================
void DesktopEnvironment::onScreenInfoChanged(QString name, QString key, QVariant value)
{
    qDebug() << name << key << value;
}

} // namespace bl
