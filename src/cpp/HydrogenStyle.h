#ifndef HYDROGENSTYLE_H
#define HYDROGENSTYLE_H

#include <QProxyStyle>

namespace bl {

class HydrogenStyle : public QProxyStyle
{
    Q_OBJECT
public:
    class Impl;

    HydrogenStyle();
    ~HydrogenStyle();

    void drawControl(ControlElement element, const QStyleOption *option,
            QPainter *painter, const QWidget *widget = nullptr) const override;

    void drawPrimitive(PrimitiveElement element, const QStyleOption *option,
            QPainter *painter, const QWidget *widget = nullptr) const override;

    int pixelMetric(PixelMetric metric, const QStyleOption *option = nullptr,
            const QWidget *widget = nullptr) const override;

    QSize sizeFromContents(ContentsType type, const QStyleOption *option,
            const QSize &size, const QWidget *widget) const override;
private:
    Impl *pImpl;
};

} // namespace bl

#endif // HYDROGENSTYLE_H
