pragma Singleton
import QtQuick 2.12
import QtQuick.Window 2.12 as QtQuickWindow

import ".."

Item {
  id: root

  enum Cursor {
    Auto,
    Arrow,
    Pointer,
    Text
  }

  //===================
  // Properties
  //===================
  property string name: "standalone"

  readonly property alias menuOpen: internal.menuOpen
  readonly property alias pixelsPerDp: internal.pixelsPerDp

  property alias overlay: overlayLoader.item

  //====================
  // Private Properties
  //====================
  QtObject {
    id: internal
    property string msg: "Hi!"
    property bool menuOpen: false
    property real pixelsPerDp: 1
  }

  //===================
  // Constants
  //===================
  property alias icons: _icons
  property alias fonts: _fonts
  property alias menus: _menus
  QtObject {
    id: _icons
    property string theme: "standalone"
    property Image goPrevious: Image {
      source: "../../../icons/standalone/scalable/actions/go-previous.svg"
    }
    property Image goNext: Image {
      source: "../../../icons/standalone/scalable/actions/go-next.svg"
    }
  }
  QtObject {
    id: _fonts
    property int x11DotsPerInch: 72   // Used only on X Window System.
  }
  QtObject {
    id: _menus
    property Menu applicationMenu: Menu {
      type: Menu.MenuType.Submenu
      title: "Application"
      MenuItem {
        title: "Quit"
        action: root.quit
      }
    }
  }

  //==================
  // Signals
  //==================

  /// \brief  Sould emitted when the menu is opening.
  signal menuOpened(Item parent, ListModel menu)
  /// \brief  Should emitted when all menus are completely closed.
  signal menuClosed()

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
          this.x = root.parent.Window.window.x + (index * 100)
          this.y = root.parent.Window.window.y + 30
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
          print('[DesktopEnvironment] _menuBarArea onEntered')
        }
      }

      Loader {
        id: overlayItemLoader
      }

      Component.onCompleted: {
        this.width = QtQuickWindow.Screen.width
        this.height = QtQuickWindow.Screen.height

        _menuBarArea.x = root.parent.Window.window.x
        _menuBarArea.y = root.parent.Window.window.y
        _menuBarArea.width = root.parent.Window.window.width
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

      overlayItemLoader.item.x = root.parent.Window.window.x
      overlayItemLoader.item.y = root.parent.Window.window.y + 30
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
      root.parent.Window.window.giveGlobalFocus()

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

  // Public methods
  function setMsg(text) {
    internal.msg = text
  }

  function quit() {
    Qt.exit(0)
  }

  // Private methods
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
