#ifndef SCREENINFO_H
#define SCREENINFO_H

#include <QObject>

#include <QRect>

namespace bl {

class ScreenInfo : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString name READ name NOTIFY nameChanged)
    Q_PROPERTY(int x READ x NOTIFY xChanged)
    Q_PROPERTY(int y READ y NOTIFY yChanged)
    Q_PROPERTY(int width READ width NOTIFY widthChanged)
    Q_PROPERTY(int height READ height NOTIFY heightChanged)
public:
    explicit ScreenInfo(QObject *parent = nullptr);
    ~ScreenInfo();

    QString name() const;
    void setName(const QString& name);

    int x() const;
    void setX(int x);

    int y() const;
    void setY(int y);

    int width() const;
    void setWidth(int width);

    int height() const;
    void setHeight(int height);

    qreal scale() const;
    void setScale(qreal scale);

signals:
    void nameChanged(QString name);
    void xChanged(int x);
    void yChanged(int y);
    void widthChanged(int width);
    void heightChanged(int height);
    void scaleChanged(qreal scale);

public slots:
    /// \brief Connect with QScreen signal geometryChanged() when creating.
    void onGeometryChanged(const QRect& geometry);

private:
    QString m_name;
    QRect m_rect;
    qreal m_scale;
};

} // namespace bl

#endif // SCREENINFO_H
