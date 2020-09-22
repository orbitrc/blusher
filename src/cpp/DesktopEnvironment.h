#ifndef DESKTOPENVIRONMENT_H
#define DESKTOPENVIRONMENT_H

#include <QObject>

#include <QVariant>

namespace bl {

class DesktopEnvironment : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QVariantMap screens READ screens NOTIFY screensChanged)
    Q_PROPERTY(QVariantMap primaryScreen READ primaryScreen NOTIFY primaryScreenChanged)
public:
    explicit DesktopEnvironment(QObject *parent = nullptr);

    QVariantMap screens() const;

    QVariantMap primaryScreen() const;

    static DesktopEnvironment *singleton;

    Q_INVOKABLE void changeScale(const QString& name, qreal scale);

signals:
    void screensChanged();
    void primaryScreenChanged();
    void screenInfoChanged(QString name, QString key, QVariant value);

public slots:

private slots:
    void onScreenInfoChanged(QString name, QString key, QVariant value);

private:
    QVariantMap m_screens;
};

} // namespace bl
#endif // DESKTOPENVIRONMENT_H
