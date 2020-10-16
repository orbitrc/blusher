#ifndef DESKTOPENVIRONMENT_H
#define DESKTOPENVIRONMENT_H

#include <QObject>

#include <QVariant>
#include <QScreen>

#include "ScreenInfo.h"

namespace bl {

class DesktopEnvironment : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QList<bl::ScreenInfo*> screens READ screens NOTIFY screensChanged)
    Q_PROPERTY(QVariantMap primaryScreen READ primaryScreen NOTIFY primaryScreenChanged)
public:
    explicit DesktopEnvironment(QObject *parent = nullptr);

    QList<ScreenInfo*> screens() const;

    QVariantMap primaryScreen() const;

    static DesktopEnvironment *singleton;

    Q_INVOKABLE void changeScale(const QString& name, qreal scale);

signals:
    /// \brief Emitted when new screen added.
    void screenAdded(QString name);
    /// \brief Emitted when the screen removed.
    void screenRemoved(QString name);
    /// \brief Emitted when one of screen's scale is changed.
    void screenScaleChanged(QString name, qreal scale);

    void screensChanged();
    void primaryScreenChanged();
    void screenInfoChanged(QString name, QString key, QVariant value);

private slots:
    void addScreen(QScreen *screen);
    void removeScreen(QScreen *screen);
    void onScreenInfoChanged(QString name, QString key, QVariant value);

public slots:

private:
    QList<ScreenInfo*> m_screens;
};

} // namespace bl
#endif // DESKTOPENVIRONMENT_H
