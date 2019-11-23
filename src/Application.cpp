#include <blusher/Application.h>

#include <QFile>

// To ignore IDE's error.
#ifndef BLUSHER_APP_NAME
#define BLUSHER_APP_NAME ""
#endif

#ifndef BLUSHER_APP_VERSION
#define BLUSHER_APP_VERSION ""
#endif

namespace bl {

Application::Application(int& argc, char *argv[])
    : QGuiApplication(argc, argv)
{
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&m_engine, &QQmlApplicationEngine::objectCreated,
                     this, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    QVariantMap process;
    QVariantMap env;

    this->readConf(&env);
    env.insert("BLUSHER_APP_NAME", BLUSHER_APP_NAME);
    env.insert("BLUSHER_APP_VERSION", BLUSHER_APP_VERSION);
#ifdef BLUSHER_DEBUG
    process_env.insert("BLUSHER_DEBUG", true);
#endif
    process.insert("env", env);
    process.insert("app", QVariant::fromValue(this));

    this->m_engine.rootContext()->setContextProperty("Process", process);

    // m_engine.addImportPath(BLUSHER_PATH);
}

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

} // namespace bl
