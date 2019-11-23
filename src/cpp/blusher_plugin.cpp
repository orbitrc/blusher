#include "blusher_plugin.h"

#include "View.h"
#include "Window.h"

#include "DesktopEnvironment.h"

static QObject* blusher_desktop_environment_singleton_provider(
    QQmlEngine *engine, QJSEngine *scriptEngine)
{
    (void)engine;
    (void)scriptEngine;

//    bl::DesktopEnvironment *desktopEnvironment = new bl::DesktopEnvironment;
//    bl::DesktopEnvironment::singleton = desktopEnvironment;
    return bl::DesktopEnvironment::singleton;
}

void BlusherPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    (void)engine;
    (void)uri;

    bl::DesktopEnvironment::singleton = new bl::DesktopEnvironment;
}

void BlusherPlugin::registerTypes(const char *uri)
{
    // @uri Blusher
    qmlRegisterType<bl::View>(uri, 0, 1, "View");
    qmlRegisterType<Window>(uri, 0, 1, "Window3");

    qmlRegisterSingletonType<bl::DesktopEnvironment>("Blusher", 0, 1, "DesktopEnvironmentPlugin", blusher_desktop_environment_singleton_provider);
}
