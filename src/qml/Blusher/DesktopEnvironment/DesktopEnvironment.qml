pragma Singleton
import QtQuick 2.12
import QtQuick.Window 2.12 as QtQuickWindow

import ".."

Item {
  id: root

  property string name: "standalone"
  readonly property alias menuOpen: internal.menuOpen
  readonly property alias msg: internal.msg

  signal menuOpened(Item parent, ListModel menu)
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
    MenuView {
      menu: overlayLoader.menu
      width: 200
      height: 200
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

      Loader {
        id: overlayItemLoader
      }

      Component.onCompleted: {
        this.width = QtQuickWindow.Screen.width
        this.height = QtQuickWindow.Screen.height
      }
    }
  }

  Loader {
    id: overlayLoader
    property Menu menu: null

    onMenuChanged: {
      const overlayItemLoader = overlayLoader.item.overlayItemLoader

      if (overlayLoader.menu) {
        overlayItemLoader.sourceComponent = undefined
        overlayItemLoader.sourceComponent = menuViewComponent

        overlayItemLoader.item.x = root.parent.MyWindow.window.x
        overlayItemLoader.item.y = root.parent.MyWindow.window.y + 30
      }
    }
  }


  onMenuOpened: {
    if (!this.menuOpen) {
      print('[DesktopEnvironment] open menu. menu: ' + menu.title)
      root.parent = parent
      // Not loaded yet.
      if (!overlayLoader.sourceComponent) {
        overlayLoader.sourceComponent = overlayComponent
      }
      overlayLoader.item.visible = true
      overlayLoader.menu = menu

      internal.menuOpen = true
    }
  }
  onMenuClosed: {
    overlayLoader.item.visible = false
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
}
