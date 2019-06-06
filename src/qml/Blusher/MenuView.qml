import QtQuick 2.12
import QtQuick.Layouts 1.12

import Blusher.DesktopEnvironment 0.1

Rectangle {
  id: root

  //===================
  // Public properties
  //===================
  property Menu menu: null

  //=========================
  // Private Properties
  //=========================
  property QtObject _private: QtObject {
    id: _private
    property bool opened: (root.menu.opened)
    onOpenedChanged: {
      if (_private.opened === false) {
        root.visible = false
      }
    }
  }

  //================
  // Style
  //================
  color: "#d6d2d0"
  border.width: 0

  implicitHeight: itemsView.implicitHeight
  implicitWidth: itemsView.implicitWidth

  MouseArea {
    anchors.fill: parent
    onClicked: {
      root.menu.focusedItemIndex = -1
    }
  }

  GridLayout {
    id: itemsView
    property alias menuItemViewList: menuItemViewList

    rows: (root.menu.type === Menu.MenuType.MenuBarMenu) ? 1 : -1
    columns: (root.menu.type !== Menu.MenuType.MenuBarMenu) ? 1 : -1
    rowSpacing: 0
    columnSpacing: 0
    Repeater {
      model: root.menu
      id: menuItemViewList
      MenuItemView {
        menuItem: root.menu.items[index] // root.menu.get(index)
        text: title

        Layout.fillWidth: true

        onClicked: {
          // If menu bar menu.
          if (root.menu.type === Menu.MenuType.MenuBarMenu) {
            if (root.menu.focusedItemIndex > -1) {
              // Menu bar menu already activated.
              root.menu.focusedItemIndex = -1
            } else {
              // Menu bar menu not activated before.
              root.menu.focusedItemIndex = index
              if (this.hasSubmenu()) {
                this.menuItem.submenu.open(MyWindow.window.contentItem)
              }
            }
          }
          // If regular menu.
          if (root.menu.type !== Menu.MenuType.MenuBarMenu) {
            if (!this.hasSubmenu()) {
              print('MenuItem.action')
            }
          }
        }
        onEntered: {
          // If menu bar menu.
          if (root.menu.type === Menu.MenuType.MenuBarMenu) {
            if (root.menu.focusedItemIndex > -1) {
              // Menu bar menu already activated.
              root.menu.focusedItemIndex = index
            }
          }
          // If regular menu.
          if (root.menu.type !== Menu.MenuType.MenuBarMenu) {
            root.menu.focusedItemIndex = index
          }
        }
        // This can be stop by MenuItemView itself.
        onExited: {
          root.menu.focusedItemIndex = -1
        }

        Component.onCompleted: {
          Layout.minimumWidth = 20
          bindMenuItem(this.menuItem, index)
        }
      }
    }
  }

  //============
  // Created
  //============
  Component.onCompleted: {
    print('[MenuView, "' + root.menu.title + '"] created')
    if (root.menu.type !== Menu.MenuType.MenuBarMenu) {
      return
    }
    // Connect to signal `menuClosed` in DesktopEnvironment.
    DesktopEnvironment.menuClosed.connect(function() {
      root.menu.focusedItemIndex = -1
    })
  }

  //==============
  // Destructed
  //==============
  Component.onDestruction: {
    print('[MenuView, "' + root.menu.title + '"] destructing...')
  }

  //==============
  // Methods
  //==============
  function bindMenuItem(item, index) {
    if (item.separator) { return }

    item.focused = Qt.binding(() => (index === root.menu.focusedItemIndex))
  }

  //=======================
  // Property changed
  //=======================
  onMenuChanged: {
  }

  //=========
  // Debug
  //=========
  Text {
//    text: root.menu.title + ": " + String(root.menu.focusedItemIndex) + "/" + String(root.menu.items.length)
    text: (root.activeFocus) ? "activeFocused" : "inactive";
    anchors.right: parent.right
  }
}
