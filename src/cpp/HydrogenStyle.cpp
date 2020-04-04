#include "HydrogenStyle.h"

#include <QStyleOption>
#include <QStyleOptionMenuItem>
#include <QPainter>
#include <QDebug>

namespace bl {
class HydrogenStyle::Impl
{
public:
    QColor menu_background_color = QColor::fromRgb(238, 238, 238);
    QColor menu_separator_color = QColor::fromRgb(0xd8, 0xd8, 0xd8);
    QColor menu_focus_color = QColor::fromRgb(173, 202, 230);
};

HydrogenStyle::HydrogenStyle()
{
    this->pImpl = new Impl;
}

HydrogenStyle::~HydrogenStyle()
{
    delete this->pImpl;
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
        painter->fillRect(option->rect, this->pImpl->menu_background_color);
        // Dummy.
        if (item_option->menuItemType != QStyleOptionMenuItem::Separator) {
            painter->fillRect(
                option->rect.x() + 1,
                option->rect.y() + 1,
                18,  18, QColor(Qt::cyan)
            );
        }
        // Separator.
        if (item_option->menuItemType == QStyleOptionMenuItem::Separator) {
            QRectF rect = option->rect;
            rect.setY(option->rect.y() + 4);
            rect.setHeight(4);
            painter->fillRect(rect, this->pImpl->menu_separator_color);
        }
        // Focus item.
        if (option->state & QStyle::State_Selected) {
            painter->fillRect(option->rect, this->pImpl->menu_focus_color);
        }
        // Draw menu item title.
        QFont font;
        font.setPixelSize(14);
        painter->setFont(font);
        painter->drawText(QRect(20, option->rect.y() + 2, 100, 20), 0, item_option->text);
        // Submenu icon.
        if (item_option->menuItemType == QStyleOptionMenuItem::SubMenu) {
            painter->drawText(QRect(option->rect.width() - 20, option->rect.y(), 20, 20), 0, ">");
        }

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
        painter->fillRect(option->rect, QColor::fromRgb(0, 0, 0, 0));
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
        return 0;
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
        int width = 20  // Check icon area.
            + fm.boundingRect(item_option->text).width()
            + 40;       // Shorcut or submenu icon area.
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
