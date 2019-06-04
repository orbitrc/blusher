import QtQuick 2.12
import QtQuick.Layouts 1.12

import Blusher.DesktopEnvironment 0.1

Rectangle {
  id: root

  //===================
  // Public properties
  //===================
  property Menu menu: null

  visible: false

  //================
  // Style
  //================
  color: "#eeedeb"
  border.width: 0

  Component {
    id: component
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

          onClicked: {
            // If menu bar menu.
            if (root.menu.type === Menu.MenuType.MenuBarMenu) {
              if (root.menu.focusedItemIndex > -1) {
                // Menu bar menu already activated.
                root.menu.focusedItemIndex = -1
                focusScope.focus = false
              } else {
                // Menu bar menu not activated before.
                root.menu.focusedItemIndex = index
                focusScope.focus = true
                this.focus = true
                if (this.hasSubmenu()) {
                  this.menuItem.submenu.open(MyWindow.window.contentItem)
                  DesktopEnvironment.menuOpened(MyWindow.window.contentItem, this.menuItem.submenu)
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
                focusScope.focus = true
                this.focus = true
              }
            }
            // If regular menu.
            if (root.menu.type !== Menu.MenuType.MenuBarMenu) {
              root.menu.focusedItemIndex = index
              focusScope.focus = true
              this.focus = true
            }
          }
          onExited: {
          }

          Component.onCompleted: {
            Layout.minimumWidth = 20
            bindMenuItem(this.menuItem, index)
          }
        }
      }

      Component.onCompleted: {
        root.visible = true
      }
    }
  }

  MouseArea {
    anchors.fill: parent
    onClicked: {
      root.menu.focusedItemIndex = -1
      focusScope.focus = false
    }
  }

  FocusScope {
    id: focusScope
    focus: true
    Loader {
      id: menuLoader
      focus: focusScope.focus
    }
  }

  //============
  // Created
  //============
  Component.onCompleted: {
    print('menu created: ' + root.menu.title)
    // Load component with loader.
    menuLoader.sourceComponent = component

    // Connect to signal `menuClosed` in DesktopEnvironment.
    if (root.menu.type !== Menu.MenuType.MenuBarMenu) {
      return
    }
    DesktopEnvironment.menuClosed.connect(function() {
      root.menu.focusedItemIndex = -1
      focusScope.focus = false
    })
  }

  //==============
  // Destructed
  //==============
  Component.onDestruction: {
    menuLoader.sourceComponent = undefined  // Is this needed?
  }

  //==============
  // Methods
  //==============
  function bindMenuItem(item, index) {
    item.focused = Qt.binding(() => (index === root.menu.focusedItemIndex))
  }

  //=======================
  // Property changed
  //=======================
  onMenuChanged: {
    if (root.menu) {
      print('[MenuView, "' + root.menu.title + '" - onMenuChanged] menu: ' + root.menu)
    }
  }

  //=========
  // Debug
  //=========
  Text {
    text: root.menu.title + ": " + String(root.menu.focusedItemIndex) + "/" + String(root.menu.items.length)
    anchors.right: parent.right
  }
}
