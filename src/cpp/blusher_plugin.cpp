#include "blusher_plugin.h"

#include <QMetaType>
#include <QGuiApplication>

#include "View.h"
#include "Box.h"
#include "BaseWindow.h"
#include "Menu.h"
#include "MenuItem.h"
#include "KeyEvent.h"
#include "Anchors.h"

#include "Blusher.h"
#include "DesktopEnvironment.h"

//======================
// Singleton providers
//======================
static QObject* blusher_blusher_singleton_provider(
    QQmlEngine *engine, QJSEngine *scriptEngine)
{
    (void)engine;
    (void)scriptEngine;

    return bl::Blusher::singleton;
}

static QObject* blusher_desktop_environment_singleton_provider(
    QQmlEngine *engine, QJSEngine *scriptEngine)
{
    (void)engine;
    (void)scriptEngine;

//    bl::DesktopEnvironment *desktopEnvironment = new bl::DesktopEnvironment;
//    bl::DesktopEnvironment::singleton = desktopEnvironment;
    return bl::DesktopEnvironment::singleton;
}

//=========================
// Initialize and register
//=========================
void BlusherPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    (void)engine;
    (void)uri;

    // Blusher
    bl::Blusher::singleton = new bl::Blusher;
    bl::Blusher::singleton->_set_app(QGuiApplication::instance());
    // DesktopEnvironment
    bl::DesktopEnvironment::singleton = new bl::DesktopEnvironment;
}

void BlusherPlugin::registerTypes(const char *uri)
{
    // @uri Blusher
    qmlRegisterType<bl::View>(uri, 0, 1, "View");
    qmlRegisterType<bl::Box>(uri, 0, 1, "Box");
    qmlRegisterType<bl::BaseWindow>(uri, 0, 1, "BaseWindow");
    qmlRegisterType<bl::Menu>(uri, 0, 1, "Menu");
    qmlRegisterType<bl::MenuItem>(uri, 0, 1, "MenuItem");

    qRegisterMetaType<bl::Menu*>("Menu*");
    qRegisterMetaType<bl::BaseWindow*>("BaseWindow*");
    qRegisterMetaType<bl::AnchorLine>("AnchorLine");

    qmlRegisterUncreatableType<bl::KeyEvent>(uri, 0, 1, "KeyEvent", "");
    qmlRegisterUncreatableType<bl::Anchors>(uri, 0, 1, "Anchors", "");

    qmlRegisterSingletonType<bl::Blusher>("Blusher", 0, 1, "Blusher", blusher_blusher_singleton_provider);
    qmlRegisterSingletonType<bl::DesktopEnvironment>("Blusher", 0, 1, "DesktopEnvironmentPlugin", blusher_desktop_environment_singleton_provider);
}
