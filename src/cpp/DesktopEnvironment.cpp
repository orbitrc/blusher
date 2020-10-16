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

        ScreenInfo *screen_info = new ScreenInfo;
        screen_info->setName(name);
        screen_info->setX(scr->geometry().x());
        screen_info->setY(scr->geometry().y());
        screen_info->setWidth(scr->geometry().width());
        screen_info->setHeight(scr->geometry().height());
        screen_info->setScale(1);
        // Connect geometry change signal.
        QObject::connect(scr, &QScreen::geometryChanged,
                         screen_info, &ScreenInfo::onGeometryChanged);

        this->m_screens.append(screen_info);
    }

    QObject::connect(app, &QApplication::primaryScreenChanged,
                     this, &DesktopEnvironment::primaryScreenChanged);

    QObject::connect(this, &DesktopEnvironment::screenInfoChanged,
                     this, &DesktopEnvironment::onScreenInfoChanged);

    QObject::connect(app, &QApplication::screenAdded,
                     this, &DesktopEnvironment::addScreen);
    QObject::connect(app, &QApplication::screenRemoved,
                     this, &DesktopEnvironment::removeScreen);
}

QList<ScreenInfo*> DesktopEnvironment::screens() const
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
    primary_screen_info["width"] = primary_screen->geometry().width();
    primary_screen_info["height"] = primary_screen->geometry().height();

    return primary_screen_info;
}

//======================
// Q_INVOKABLE methods
//======================
void DesktopEnvironment::changeScale(const QString &name, qreal scale)
{
    for (auto&& screen: this->m_screens) {
        if (screen->name() == name) {
            screen->setScale(scale);

            emit this->screenScaleChanged(name, scale);
            break;
        }
    }
}

//=====================
// Private slots
//=====================

void DesktopEnvironment::addScreen(QScreen *screen)
{
    ScreenInfo *screen_info = new ScreenInfo;
    QRect geometry = screen->geometry();

    screen_info->setName(screen->name());
    screen_info->setX(geometry.x());
    screen_info->setY(geometry.y());
    screen_info->setWidth(geometry.width());
    screen_info->setHeight(geometry.height());

    QObject::connect(screen, &QScreen::geometryChanged,
                     screen_info, &ScreenInfo::onGeometryChanged);

    this->m_screens.append(screen_info);

    emit this->screenAdded(screen_info->name());
    emit this->screensChanged();
}

void DesktopEnvironment::removeScreen(QScreen *screen)
{
    const QString& name = screen->name();
    ScreenInfo *screen_info = nullptr;

    for (auto&& info: this->m_screens) {
        if (info->name() == name) {
            screen_info = info;
            break;
        }
    }

    if (screen_info != nullptr) {
        this->m_screens.removeOne(screen_info);
    } else {
        qDebug() << "DesktopEnvironment::removeScreen - Failed to remove screen info.";
        return;
    }

    emit this->screenRemoved(screen_info->name());
    emit this->screensChanged();
}

void DesktopEnvironment::onScreenInfoChanged(QString name, QString key, QVariant value)
{
    qDebug() << name << key << value;
}

} // namespace bl
