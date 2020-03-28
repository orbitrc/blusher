#ifndef HYDROGENSTYLE_H
#define HYDROGENSTYLE_H

#include <QProxyStyle>

namespace bl {

class HydrogenStyle : public QProxyStyle
{
    Q_OBJECT
public:
    HydrogenStyle();

    void drawControl(ControlElement element, const QStyleOption *option,
            QPainter *painter, const QWidget *widget = nullptr) const override;

    void drawPrimitive(PrimitiveElement element, const QStyleOption *option,
            QPainter *painter, const QWidget *widget = nullptr) const override;

    int pixelMetric(PixelMetric metric, const QStyleOption *option = nullptr,
            const QWidget *widget = nullptr) const override;

    QSize sizeFromContents(ContentsType type, const QStyleOption *option,
            const QSize &size, const QWidget *widget) const override;
};

} // namespace bl

#endif // HYDROGENSTYLE_H
