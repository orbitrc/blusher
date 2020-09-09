#include "Blusher.h"

#include <QClipboard>

#include <blusher/Application.h>

namespace bl {

Blusher *Blusher::singleton = nullptr;

Blusher::Blusher(QObject *parent)
    : QObject(parent)
{

}

Application* Blusher::app() const
{
    return static_cast<Application*>(this->p_app);
}

void Blusher::_set_app(QObject *app)
{
    this->p_app = app;
}

void Blusher::copyTextToClipboard(QString text)
{
    this->app()->clipboard()->setText(text);
}

QRectF Blusher::menuBarRect() const
{
    return this->m_menuBarRect;
}

void Blusher::setMenuBarRect(QRectF rect)
{
    this->m_menuBarRect = rect;
}

QRectF Blusher::menuBarMenuItemRect() const
{
    return this->m_menuBarMenuItemRect;
}

void Blusher::setMenuBarMenuItemRect(QRectF rect)
{
    this->m_menuBarMenuItemRect = rect;
}


} // namespace bl
