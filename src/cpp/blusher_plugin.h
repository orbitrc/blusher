#ifndef BLUSHER_PLUGIN_H
#define BLUSHER_PLUGIN_H

#include <QQmlExtensionPlugin>

class BlusherPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)

public:
    void initializeEngine(QQmlEngine *engine, const char *uri) override;
    void registerTypes(const char *uri) override;
};

#endif /* BLUSHER_PLUGIN_H */
