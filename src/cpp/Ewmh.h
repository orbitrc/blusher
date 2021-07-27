#ifndef EWMH_H
#define EWMH_H

#include <stdint.h>

#include <QObject>

#include <blusher/blusher.h>

#ifdef BL_PLATFORM_LINUX
#include <xcb/xcb.h>
#endif

#include "BaseWindow.h"

class Ewmh
{
public:
    Ewmh();

#ifdef BL_PLATFORM_LINUX
    //=================================
    // Application window properties
    //=================================
//    static QString get_net_wm_name(uint32_t w);
//    static uint32_t get_net_wm_desktop(uint32_t w);
    static uint32_t get_net_wm_desktop(uint32_t w);

    static void set_net_wm_desktop(uint32_t w, uint32_t desktop);

    static QList<int> get_net_wm_strut_partial(uint32_t w);

    static void set_net_wm_strut_partial(uint32_t w, QList<int> strut);

    static QList<bl::BaseWindow::NetWmWindowType> get_net_wm_window_type(uint32_t w);

    static void set_net_wm_window_type(uint32_t w, bl::BaseWindow::NetWmWindowType type, bool replace = false);

    static void set_wm_transient_for(uint32_t w, uint32_t parent);

private:
    static xcb_atom_t get_atom(xcb_connection_t *conn, const QString& atom);

    static xcb_get_property_cookie_t get_property(xcb_connection_t *conn,
            xcb_window_t w, const QString& prop, xcb_atom_t type);

    static void change_property(xcb_connection_t *conn, uint8_t mode,
            xcb_window_t w, const QString& prop, xcb_atom_t type,
            size_t data_len,void *data);
#endif // BL_PLATFORM_LINUX
};

#endif // EWMH_H
