import QtQuick 2.12
import QtQuick.Layouts 1.12

import ".."       // Blusher.DesktopEnvironment
import "../.."    // Blusher
import "." as Standalone

import "../../../../js/path.js" as Path

Rectangle {
  id: root

  //===================
  // Public properties
  //===================
  property Menu menu: null
  property Menu applicationMenu: DesktopEnvironment.menus.applicationMenu

  property bool popUpMenuBar: false

  property bool active: false
  property bool applicationMenuFocused: false
  property int focusedItemIndex: -1

  property var _menuItems: []

  //================
  // Style
  //================
  height: DesktopEnvironment.menuBarHeight * DesktopEnvironment.pixelsPerDp
  implicitWidth: itemsView.implicitWidth
  width: this.implicitWidth

  Rectangle {
    id: _styler
    anchors.fill: parent
    color: "#d6d2d0"
    border.width: 0
  }

  RowLayout {
    id: itemsView
    property alias menuItemViewList: menuItemViewList

    spacing: 0
    // Application menu
    Standalone.MenuBarMenuItemDelegate {
      menuItem: root.applicationMenu
      focused: root.applicationMenuFocused
      menuBarActive: root.popUpMenuBar
      bold: true

      Layout.alignment: Qt.AlignTop
      Layout.fillHeight: true

      onPressed: {
        if (!root.popUpMenuBar) {
          DesktopEnvironment.onMenuOpened();
          DesktopEnvironment.overlay.activateMenuBar();
        } else {
          DesktopEnvironment.onMenuClosed();
        }
      }

      onClicked: {
      }
      onEntered: {
        if (root.popUpMenuBar) {
          root.focusedItemIndex = -1;
          root.applicationMenuFocused = true;
          root.openSubmenu(root.applicationMenu.items,
            DesktopEnvironment.overlay.menuBarLoader.x,
            DesktopEnvironment.overlay.menuBarLoader.y + 30);
        }
      }
    }

    // Menu items
    Repeater {
      model: root._menuItems
      id: menuItemViewList

      Standalone.MenuBarMenuItemDelegate {
        menuItem: root._menuItems[index]
        focused: (root.focusedItemIndex === index)
        menuBarActive: root.popUpMenuBar

        Layout.minimumHeight: root.height

        onPressed: {
          if (!root.popUpMenuBar) {
            DesktopEnvironment.onMenuOpened();
            DesktopEnvironment.overlay.activateMenuBar();
          } else {
            DesktopEnvironment.onMenuClosed();
          }
        }
        onEntered: {
          if (!root.popUpMenuBar) {
            return;
          }

          if (root.focusedItemIndex !== index || root.applicationMenuFocused) {
            root.applicationMenuFocused = false;
            root.focusedItemIndex = index;
            root.openSubmenu(root.filterItems(root.menu, this.menuItem.path),
              DesktopEnvironment.overlay.menuBarLoader.x + this.x,
              DesktopEnvironment.overlay.menuBarLoader.y + 30 + this.y);
          }
        }
      }
    }
  }

  Loader {
    id: popUpMenuLoader
  }

  onVisibleChanged: {
    print('asdf');
  }

  onMenuChanged: {
    if (root.menu) {
      const menu = root.menu;

      root._menuItems = [];
      for (let i = 0; i < menu.items.length; ++i) {
        // Ignore separator.
        if (menu.items[i].separator) {
          continue;
        }
        if (Path.join(menu.items[i].path, '..') === '/') {
          root._menuItems.push(menu.items[i]);
        }
      }
    }
  }

  //==========================
  // Methods
  //==========================

  // Open submenu as pop up menu with list of menu items.
  function openSubmenu(items, x, y) {
    popUpMenuLoader.setSource('PopUpMenuDelegate.qml', { items: items });
    popUpMenuLoader.item.x = x;
    popUpMenuLoader.item.y = y;
    popUpMenuLoader.item.show();
  }

  // Get child items of given menu by path.
  function filterItems(menu, path) {
    if (!path.endsWith('/')) {
      print('Not a submenu! path: ' + path);
    }
    const resolvedMenuPath = Path.join(path, '.');
    let filtered = [];

    for (let i = 0; i < menu.items.length; ++i) {
      let item = menu.items[i];
      if (item.separator) {
        continue;
      }
      if (Path.join(menu.items[i].path, '..') === resolvedMenuPath) {
        filtered.push(menu.items[i]);
      }
    }
    return filtered;
  }
}

