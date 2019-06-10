pragma Singleton
import QtQuick 2.12
import QtQuick.Window 2.12 as QtQuickWindow

import ".."

Item {
  id: root

  property string name: "standalone"

  readonly property alias menuOpen: internal.menuOpen
  readonly property alias msg: internal.msg

  property alias overlay: overlayLoader.item

  /// \brief  Sould emitted when the menu is opening.
  signal menuOpened(Item parent, ListModel menu)
  /// \brief  Should emitted when all menus are completely closed.
  signal menuClosed()

  QtObject {
    id: internal
    property string msg: "Hi!"
    property bool menuOpen: false
  }

  //===================
  // Components
  //===================

  // MenuView component
  Component {
    id: menuViewComponent
    Repeater {
      model: overlayLoader.menus.length
      MenuView {
        menu: overlayLoader.menus[index]

        Component.onCompleted: {
          this.x = root.parent.MyWindow.window.x + (index * 100)
          this.y = root.parent.MyWindow.window.y + 30
        }

        onVisibleChanged: {
          if (this.visible === false) {
            root._popMenu()
          }
        }
      }
    }
  }

  // Overlay component
  Component {
    id: overlayComponent
    QtQuickWindow.Window {
      id: _window

      property alias overlayItemLoader: overlayItemLoader

      visible: true
      flags: Qt.Popup
      color: "#11220000" // "#00000000"

      MouseArea {
        anchors.fill: parent

        onClicked: {
          root.menuClosed()
        }
      }

      MouseArea {
        id: _menuBarArea
        hoverEnabled: true
        propagateComposedEvents: true
        height: 30

        onEntered: {
          print('menu bar')
        }
      }

      Loader {
        id: overlayItemLoader
      }

      Component.onCompleted: {
        this.width = QtQuickWindow.Screen.width
        this.height = QtQuickWindow.Screen.height

        _menuBarArea.x = root.parent.MyWindow.window.x
        _menuBarArea.y = root.parent.MyWindow.window.y
        _menuBarArea.width = root.parent.MyWindow.window.width
      }
    }
  }

  Loader {
    id: overlayLoader
    property list<Menu> menus

    onMenusChanged: {
      const overlayItemLoader = root.overlay.overlayItemLoader

      overlayItemLoader.sourceComponent = undefined
      overlayItemLoader.sourceComponent = menuViewComponent

      overlayItemLoader.item.x = root.parent.MyWindow.window.x
      overlayItemLoader.item.y = root.parent.MyWindow.window.y + 30
    }
  }


  onMenuOpened: {
    if (!this.menuOpen) {
      print('[DesktopEnvironment] open menu. menu: ' + menu.title)
      // Set singleton item child of root window.
      // It is important to refer the geometry of root window such as x and y.
      root.parent = parent
      // Load if not loaded yet.
      if (!overlayLoader.sourceComponent) {
        overlayLoader.sourceComponent = overlayComponent
      }
      overlayLoader.menus.push(menu)
      root.overlay.visible = true

      // Give global focus to the root window.
      root.parent.MyWindow.window.giveGlobalFocus()

      internal.menuOpen = true
    } else {
      if (menu.type === Menu.MenuType.Submenu) {
        overlayLoader.menus.push(menu)
      } else {
        overlayLoader.menus = []
        overlayLoader.menus.push(menu)
      }
    }
  }
  onMenuClosed: {
    for (let i = overlayLoader.menus.length - 1; i >= 0; --i) {
      print('[DesktopEnvironment] closing menu: ' + overlayLoader.menus[i].title)
      overlayLoader.menus[i].close()
    }
    overlayLoader.menus = []
    root.overlay.visible = false
    internal.menuOpen = false
  }

  Component.onCompleted: {
    print('[DesktopEnvironment.onCompleted]')
  }

  Component.onDestruction: {
    print('[DesktopEnvironment.onDestruction]')
    overlayLoader.sourceComponent = undefined
  }

  //=============
  // Methods
  //=============
  function setMsg(text) {
    internal.msg = text
  }

  function _openSubmenu(menu) {
    const prevMenu = overlayLoader.menus[overlayLoader.menus.length -1]
  }

  function _popMenu() {
    print('[DesktopEnvironment._popMenu] pop: ' + overlayLoader.menus[overlayLoader.menus.length - 1].title)
    let newMenus = []
    for (let i = 0; i < overlayLoader.menus.length - 1; ++i) {
      newMenus.push(overlayLoader.menus[i])
    }
    overlayLoader.menus = newMenus
  }
}
