#include "HydrogenStyle.h"

#include <QStyleOption>
#include <QStyleOptionMenuItem>
#include <QPainter>
#include <QDebug>

namespace bl {
HydrogenStyle::HydrogenStyle()
{
}

void HydrogenStyle::drawControl(ControlElement element,
        const QStyleOption *option, QPainter *painter, const QWidget *widget) const
{
    switch (element) {
    case CE_MenuEmptyArea:
    {
        painter->fillRect(option->rect, Qt::yellow);

        break;
    }
    case CE_MenuItem:
    {
        const QStyleOptionMenuItem *item_option =
            qstyleoption_cast<const QStyleOptionMenuItem*>(option);

        // Background color.
        painter->fillRect(option->rect, QColor::fromRgb(238, 238, 238));
        // Dummy.
        if (item_option->menuItemType != QStyleOptionMenuItem::Separator) {
            painter->fillRect(
                option->rect.x() + 1,
                option->rect.y() + 1,
                18,  18, QColor(Qt::red)
            );
        }
        // Separator.
        if (item_option->menuItemType == QStyleOptionMenuItem::Separator) {
            QRectF rect = option->rect;
            rect.setY(option->rect.y() + 4);
            rect.setHeight(4);
            painter->fillRect(rect, QColor::fromRgb(0xd8, 0xd8, 0xd8));
        }
        // Focus item.
        if (option->state & QStyle::State_Selected) {
            painter->fillRect(option->rect, QColor::fromRgb(173, 202, 230));
        }
        // Draw menu item title.
        QFont font;
        font.setPixelSize(14);
        painter->setFont(font);
        painter->drawText(QRect(32, option->rect.y(), 100, 20), 0, item_option->text);
//        QProxyStyle::drawControl(element, option, painter, widget);

        break;
    }
    default:
        QProxyStyle::drawControl(element, option, painter, widget);
    }
}

void HydrogenStyle::drawPrimitive(PrimitiveElement element,
        const QStyleOption *option, QPainter *painter, const QWidget *widget) const
{
    switch (element) {
    case PE_FrameMenu:
    {
        painter->fillRect(option->rect, Qt::red);
        break;
    }
    default:
        QProxyStyle::drawPrimitive(element, option, painter, widget);
    }
}

int HydrogenStyle::pixelMetric(PixelMetric metric, const QStyleOption *option,
        const QWidget *widget) const
{
    switch (metric) {
    case PM_MenuVMargin:
        return 20;
    default:
        return QProxyStyle::pixelMetric(metric, option, widget);
    }
}

QSize HydrogenStyle::sizeFromContents(ContentsType type,
        const QStyleOption *option, const QSize &size, const QWidget *widget) const
{
    switch (type) {
    case CT_MenuItem:
    {
        const QStyleOptionMenuItem *item_option =
            qstyleoption_cast<const QStyleOptionMenuItem*>(option);

        QFont font = item_option->font;
        font.setPixelSize(14);
        QFontMetrics fm(font);
        int width = fm.boundingRect(item_option->text).width();
        width += 40;
        int height = 20;
        if (item_option->menuItemType == QStyleOptionMenuItem::Separator) {
            height = 12;
        }
        return QSize(width, height);
    }
    default:
        return QProxyStyle::sizeFromContents(type, option, size, widget);
    }
}

} // namespace bl
