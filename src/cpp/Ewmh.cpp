#include "Ewmh.h"

#include <stdlib.h>

#include <xcb/xcb_ewmh.h>

Ewmh::Ewmh()
{
}

QList<bl::BaseWindow::WindowType> Ewmh::get_net_wm_window_type(uint32_t w)
{
    xcb_connection_t *conn = xcb_connect(NULL, NULL);

    xcb_atom_t net_wm_window_type_desktop = Ewmh::get_atom(conn, "_NET_WM_WINDOW_TYPE_DESKTOP");
    xcb_atom_t net_wm_window_type_dock = Ewmh::get_atom(conn, "_NET_WM_WINDOW_TYPE_DOCK");
    xcb_atom_t net_wm_window_type_toolbar = Ewmh::get_atom(conn, "_NET_WM_WINDOW_TYPE_TOOLBAR");
    xcb_atom_t net_wm_window_type_menu = Ewmh::get_atom(conn, "_NET_WM_WINDOW_TYPE_MENU");
    xcb_atom_t net_wm_window_type_utility = Ewmh::get_atom(conn, "_NET_WM_WINDOW_TYPE_UTILITY");
    xcb_atom_t net_wm_window_type_splash = Ewmh::get_atom(conn, "_NET_WM_WINDOW_TYPE_SPLASH");
    xcb_atom_t net_wm_window_type_dialog = Ewmh::get_atom(conn, "_NET_WM_WINDOW_TYPE_DIALOG");
    xcb_atom_t net_wm_window_type_drop_down_menu = Ewmh::get_atom(conn, "_NET_WM_WINDOW_TYPE_DROPDOWN_MENU");
    xcb_atom_t net_wm_window_type_pop_up_menu = Ewmh::get_atom(conn, "_NET_WM_WINDOW_TYPE_POPUP_MENU");
    xcb_atom_t net_wm_window_type_tool_tip = Ewmh::get_atom(conn, "_NET_WM_WINDOW_TYPE_TOOLTIP");
    xcb_atom_t net_wm_window_type_notification = Ewmh::get_atom(conn, "_NET_WM_WINDOW_TYPE_NOTIFICATION");
    xcb_atom_t net_wm_window_type_combo = Ewmh::get_atom(conn, "_NET_WM_WINDOW_TYPE_COMBO");
    xcb_atom_t net_wm_window_type_dnd = Ewmh::get_atom(conn, "_NET_WM_WINDOW_TYPE_DND");
    xcb_atom_t net_wm_window_type_normal = Ewmh::get_atom(conn, "_NET_WM_WINDOW_TYPE_NORMAL");

    xcb_get_property_cookie_t cookie = Ewmh::get_property(conn, w, "_NET_WM_WINDOW_TYPE", XCB_ATOM_ATOM);
    xcb_get_property_reply_t *reply = xcb_get_property_reply(conn, cookie, NULL);
    size_t len = xcb_get_property_value_length(reply);
    void *val = xcb_get_property_value(reply);

    using WindowType = bl::BaseWindow::WindowType;
    QList<bl::BaseWindow::WindowType> list;
    for (size_t i = 0; i < len; ++i) {
        xcb_atom_t type = ((xcb_atom_t*)val)[i];
        if (type == net_wm_window_type_desktop) {
            list.append(WindowType::Desktop);
        } else if (type == net_wm_window_type_dock) {
            list.append(WindowType::Dock);
        } else if (type == net_wm_window_type_toolbar) {
            list.append(WindowType::Toolbar);
        } else if (type == net_wm_window_type_menu) {
            list.append(WindowType::Menu);
        } else if (type == net_wm_window_type_utility) {
            list.append(WindowType::Utility);
        } else if (type == net_wm_window_type_splash) {
            list.append(WindowType::Splash);
        } else if (type == net_wm_window_type_dialog) {
            list.append(WindowType::Dialog);
        } else if (type == net_wm_window_type_drop_down_menu) {
            list.append(WindowType::DropDownMenu);
        } else if (type == net_wm_window_type_pop_up_menu) {
            list.append(WindowType::PopUpMenu);
        } else if (type == net_wm_window_type_tool_tip) {
            list.append(WindowType::ToolTip);
        } else if (type == net_wm_window_type_notification) {
            list.append(WindowType::Notification);
        } else if (type == net_wm_window_type_combo) {
            list.append(WindowType::Combo);
        } else if (type == net_wm_window_type_dnd) {
            list.append(WindowType::Dnd);
        } else if (type == net_wm_window_type_normal) {
            list.append(WindowType::Normal);
        }
    }

    free(reply);
    xcb_disconnect(conn);

    return list;
}

void Ewmh::set_net_wm_window_type(uint32_t w, bl::BaseWindow::WindowType type, bool replace)
{
    xcb_connection_t *conn = xcb_connect(NULL, NULL);

    uint8_t mode = (replace ? XCB_PROP_MODE_REPLACE : XCB_PROP_MODE_PREPEND);

    using WindowType = bl::BaseWindow::WindowType;
    const char *type_str;
    switch (type) {
    case WindowType::Desktop:
        type_str = "_NET_WM_WINDOW_TYPE_DESKTOP";
        break;
    case WindowType::Dock:
        type_str = "_NET_WM_WINDOW_TYPE_DOCK";
        break;
    case WindowType::Toolbar:
        type_str = "_NET_WM_WINDOW_TYPE_TOOLBAR";
        break;
    case WindowType::Menu:
        type_str = "_NET_WM_WINDOW_TYPE_MENU";
        break;
    case WindowType::Utility:
        type_str = "_NET_WM_WINDOW_TYPE_UTILITY";
        break;
    case WindowType::Splash:
        type_str = "_NET_WM_WINDOW_TYPE_SPLASH";
        break;
    case WindowType::Dialog:
        type_str = "_NET_WM_WINDOW_TYPE_DIALOG";
        break;
    case WindowType::DropDownMenu:
        type_str = "_NET_WM_WINDOW_TYPE_DROPDOWN_MENU";
        break;
    case WindowType::PopUpMenu:
        type_str = "_NET_WM_WINDOW_TYPE_POPUP_MENU";
        break;
    case WindowType::ToolTip:
        type_str = "_NET_WM_WINDOW_TYPE_TOOLTIP";
        break;
    case WindowType::Notification:
        type_str = "_NET_WM_WINDOW_TYPE_NOTIFICATION";
        break;
    case WindowType::Combo:
        type_str = "_NET_WM_WINDOW_TYPE_COMBO";
        break;
    case WindowType::Dnd:
        type_str = "_NET_WM_WINDOW_TYPE_DND";
        break;
    case WindowType::Normal:
        type_str = "_NET_WM_WINDOW_TYPE_NORMAL";
        break;
    }

    xcb_atom_t type_atom = Ewmh::get_atom(conn, type_str);

    Ewmh::change_property(conn, mode, w, "_NET_WM_WINDOW_TYPE", XCB_ATOM_ATOM, 1, (void*)(&type_atom));

    xcb_disconnect(conn);
}

QList<int> Ewmh::get_net_wm_strut_partial(uint32_t w)
{
    xcb_connection_t *conn = xcb_connect(NULL, NULL);

    xcb_get_property_cookie_t cookie = Ewmh::get_property(conn, w,
        "_NET_WM_STRUT_PARTIAL", XCB_ATOM_CARDINAL);
    xcb_get_property_reply_t *reply = xcb_get_property_reply(conn, cookie, NULL);
    size_t len = xcb_get_property_value_length(reply);
    QList<int> strut;
    // Value length must be 12.
    if (len == 12) {
        free(reply);
        return strut;
    }
    void *ret = xcb_get_property_value(reply);
    for (size_t i = 0; i < 12; ++i) {
        strut.push_back(((uint32_t*)ret)[i]);
    }

    free(reply);
    xcb_disconnect(conn);

    return strut;
}

void Ewmh::set_net_wm_strut_partial(uint32_t w, QList<int> strut)
{
    xcb_connection_t *conn = xcb_connect(NULL, NULL);

    if (strut.length() != 12) {
        return;
    }

    uint32_t data[12];
    for (int i = 0; i < strut.length(); ++i) {
        data[i] = strut.value(i);
    }

    Ewmh::change_property(conn, XCB_PROP_MODE_REPLACE, w, "_NET_WM_STRUT_PARTIAL",
        XCB_ATOM_CARDINAL, 12, (void*)data);

    xcb_disconnect(conn);
}

uint32_t Ewmh::get_net_wm_desktop(uint32_t w)
{
    xcb_connection_t *conn = xcb_connect(NULL, NULL);

    xcb_get_property_cookie_t cookie = Ewmh::get_property(conn, w,
        "_NET_WM_DESKTOP", XCB_ATOM_CARDINAL);
    xcb_get_property_reply_t *reply = xcb_get_property_reply(conn, cookie, NULL);
    uint32_t value = *(uint32_t*)reply;

    free(reply);
    xcb_disconnect(conn);

    return value;
}

void Ewmh::set_net_wm_desktop(uint32_t w, uint32_t desktop)
{
    xcb_connection_t *conn = xcb_connect(NULL, NULL);

    Ewmh::change_property(conn, XCB_PROP_MODE_REPLACE, w, "_NET_WM_DESKTOP",
        XCB_ATOM_CARDINAL, 1, (void*)&desktop);

    xcb_disconnect(conn);
}

void Ewmh::set_wm_transient_for(uint32_t w, uint32_t parent)
{
    xcb_connection_t *conn = xcb_connect(NULL, NULL);

    Ewmh::change_property(conn, XCB_PROP_MODE_REPLACE, w, "WM_TRANSIENT_FOR",
        XCB_ATOM_WINDOW, 1, (void*)&parent);

    xcb_disconnect(conn);
}

//=====================
// Private functions
//=====================
xcb_atom_t Ewmh::get_atom(xcb_connection_t *conn, const QString &atom)
{
    xcb_intern_atom_cookie_t cookie = xcb_intern_atom(
        conn,
        1,
        atom.length(),
        atom.toStdString().c_str()
    );
    xcb_intern_atom_reply_t *reply = xcb_intern_atom_reply(conn, cookie, NULL);
    xcb_atom_t reply_atom = reply->atom;
    free(reply);

    return reply_atom;
}

xcb_get_property_cookie_t Ewmh::get_property(xcb_connection_t *conn,
        xcb_window_t w, const QString &prop, xcb_atom_t type)
{
    xcb_atom_t atom_prop = Ewmh::get_atom(conn, prop);

    xcb_get_property_cookie_t cookie = xcb_get_property(
        conn,
        0,
        w,
        atom_prop,
        type,
        0,
        1024
    );

    return cookie;
}

void Ewmh::change_property(xcb_connection_t *conn, uint8_t mode,
        xcb_window_t w, const QString &prop, xcb_atom_t type,
        size_t data_len, void *data)
{
    xcb_atom_t atom = Ewmh::get_atom(conn, prop);

    xcb_void_cookie_t cookie = xcb_change_property_checked(conn, mode, w,
        atom, type, 32, data_len, data);
    xcb_flush(conn);

    xcb_generic_error_t *err = xcb_request_check(conn, cookie);
    if (err) {
        qDebug() << "Failed to change property: " << err->major_code;
    }
}
