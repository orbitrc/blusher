#include "Blusher.h"

#include <QClipboard>

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

} // namespace bl
