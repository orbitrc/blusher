import QtQuick 2.12
import QtQuick.Window 2.12 as QtQuickWindow
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

import ".."       // Blusher.DesktopEnvironment
import Blusher 0.1    // Blusher
import "." as Standalone

import "../../../../js/path.js" as Path

BaseWindow {
  id: root

  property Menu menu: null
  property var items: []
  property string path

  property int focusedItemIndex: -1

  type: BaseWindow.WindowType.Menu
  flags: Qt.Tool | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint

  visible: true
  //================
  // Style
  //================
  height: itemsView.implicitHeight
  width: itemsView.implicitWidth

  Rectangle {
    id: _menuStyler
    anchors.fill: parent
    color: "#d6d2d0"
    border.width: 1
    border.color: "#ddffffff"
    radius: 3
  }
  DropShadow {
    anchors.fill: _menuStyler
    verticalOffset: 0
    radius: 7.0
    color: "#000000"
    source: _menuStyler
  }

  ColumnLayout {
    id: itemsView
    property alias menuItemViewList: menuItemViewList

    spacing: 0
    // Menu items
    Repeater {
      model: root.menu
      id: menuItemViewList
      Standalone.MenuItemDelegate {
        menuItem: root.menu.items[index]
//        focused: (root.focusedItemIndex === index)

        onClicked: {
          this.trigger();
          DesktopEnvironment.overlay.close();
        }

        onEntered: {
          root.focusedItemIndex = index;
          if (this.menuItem.path.endsWith('/')) {
            print('===== onEntered =====');
            print(this.menuItem.path);
            print(JSON.stringify(root.items));
            print(' pos: ' + root.x + 'x' + root.y);
            print('-----------------------');
            root.openSubmenu(this.menuItem.path, root.childItems(root.items, this.menuItem.path),
              root.x + root.width,
              root.y);
          }
        }
      }
    }
  }

  Loader {
    id: popUpMenuLoader
  }

  FocusScope {
    focus: true

    Keys.onPressed: {
      let lastMenu = null;

      switch (event.key) {
      case Qt.Key_Escape:
        root.close();
        break;

      case Qt.Key_Down:
        if (root.menu.focusedItemIndex === -1) {
          root.menu.focusFirstItem();
        } else {
          root.menu.focusNextItem();
        }
        break;

      case Qt.Key_Up:
        if (root.menu.focusedItemIndex === -1) {
          root.menu.focusLastItem();
        } else {
          root.menu.focusPreviousItem();
        }
        break;

      case Qt.Key_Right:
        break;

      default:
        break;
      }
    }
  }


  onItemsChanged: {
    print('=======onItemsChanged==========');
    print(' items: ' + JSON.stringify(root.items));
    print(' path:  ' + root.path);
    root._menuItems = root.filterItems(root.items, root.path);
    print(' filtered: ' + JSON.stringify(root._menuItems));
    print('-------------------------------');
  }

  //==========================
  // Methods
  //==========================

  // Open submenu as pop up menu with list of menu items.
  function openSubmenu(path, items, x, y) {
    if (popUpMenuLoader.sourceComponent) {
      popUpMenuLoader.sourceComponent = undefined;
    }
    popUpMenuLoader.setSource('PopUpMenuDelegate.qml', { path: path, items: items });
    popUpMenuLoader.item.x = x;
    popUpMenuLoader.item.y = y;
    popUpMenuLoader.item.show();
  }

  // Get all children of path.
  function childItems(items, path) {
    if (!path.endsWith('/')) {
      print('Not a submenu! path: ' + path);
    }
    let itemList = [];
    for (let i = 0; i < items.length; ++i) {
      let item = items[i];
      if (item.path !== path && item.path.startsWith(path)) {
        itemList.push(item);
      }
    }
    return itemList;
  }

  // Filter menu items by path.
  function filterItems(items, path) {
    if (!path.endsWith('/')) {
      print('Not a submenu! path: ' + path);
    }
    const resolvedMenuPath = Path.join(path, '.');
    let filtered = [];

    for (let i = 0; i < items.length; ++i) {
      let item = items[i];
      if (Path.join(item.path, '..') === resolvedMenuPath) {
        print(' item: ' + JSON.stringify(item));
        filtered.push(item);
      }
    }
    return filtered;
  }
}
