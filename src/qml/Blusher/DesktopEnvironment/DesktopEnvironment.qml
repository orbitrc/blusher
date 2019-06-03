pragma Singleton
import QtQuick 2.12
import QtQuick.Window 2.12 as QtQuickWindow

import Blusher 0.1

Item {
  id: root

  property string name: "standalone"
  readonly property alias menuOpen: internal.menuOpen
  readonly property alias msg: internal.msg

  signal menuOpened(Item parent, Item menu)
  signal menuClosed()

  QtObject {
    id: internal
    property string msg: "Hi!"
    property bool menuOpen: false
  }
  Loader {
    id: _menuLoader
  }

  //===================
  // Components
  //===================
  Component {
    id: _windowComponent
    QtQuickWindow.Window {
      id: _window
      visible: true
      flags: Qt.Popup
      color: "#44ff0000"

      MouseArea {
        anchors.fill: parent

        onClicked: {
          _window.visible = false
          root.menuClosed()
        }
      }

      Component.onCompleted: {
        this.width = QtQuickWindow.Screen.width
        this.height = QtQuickWindow.Screen.height
      }
    }
  }

  function setMsg(text) {
    internal.msg = text
  }

  onMenuOpened: {
    if (!this.menuOpen) {
      print('[DesktopEnvironment] open menu. menu.parent: ' + menu.parent)
      root.parent = parent
      menu.view.parent = _menuLoader.item
      if (!_menuLoader.sourceComponent) {
        _menuLoader.sourceComponent = _windowComponent
      } else {
        _menuLoader.item.visible = true
      }

      internal.menuOpen = true
    }
  }
  onMenuClosed: {
    internal.menuOpen = false
  }

  Component.onCompleted: {
    print('[DesktopEnvironment.onCompleted]')
  }
}
