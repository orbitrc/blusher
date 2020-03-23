#include <blusher/Application.h>

#include <QFile>

#include <QWidget>

#include "../src/cpp/Menu.h"
#include "../src/cpp/MenuItem.h"
#include "../src/cpp/MenuView.h"


namespace bl {

Application* Application::self = nullptr;


void Application::readConf(QVariantMap *env)
{
    QFile f("/etc/blusher.conf");
    if (!f.exists()) {
        env->insert("BLUSHER_DE_MODULE_PATH", "");
        return;
    }
    f.open(QFile::ReadOnly | QFile::Text);
    QString conf = QString(f.readAll());
    f.close();
    QStringList lines = conf.split("\n");
    // Parse file.
    for (int32_t i = 0; i < lines.length(); ++i) {
        // Ignore comment lines.
        if (lines[i].startsWith("#")) {
            continue;
        }
        QStringList key_value = lines[i].split("=");
        // Desktop environment module path.
        if (key_value[0] == "desktop_environment_path") {
            env->insert("BLUSHER_DE_MODULE_PATH", key_value[1]);
            this->m_engine.addImportPath(key_value[1]);
        }
    }
}

Application* Application::instance()
{
    return Application::self;
}

int Application::exec()
{
    return QApplication::exec();
}

void Application::openMenu(bl::Menu *menu, double x, double y)
{
    MenuView *qmenu = menu->to_qmenu();
    QObject::connect(qmenu, &MenuView::closedByUser,
                     this, &Application::menuClosedByUser);
    qmenu->popup(QPoint(x, y));
}

QRectF Application::menuBarRect() const
{
    return this->m_menuBarRect;
}

void Application::setMenuBarRect(QRectF rect)
{
    this->m_menuBarRect = rect;
}

QRectF Application::menuBarMenuItemRect() const
{
    return this->m_menuBarMenuItemRect;
}

void Application::setMenuBarMenuItemRect(QRectF rect)
{
    this->m_menuBarMenuItemRect = rect;
}

} // namespace bl
