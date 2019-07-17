import QtQuick 2.12
import QtQuick.Window 2.12

import ".."       // Blusher.DesktopEnvironment

Window {
  id: _debugPanel
  flags: Qt.Popup

  width: 300
  height: 300
  visible: true

  color: "#000000"
  opacity: 0.8
  Rectangle {
    id: _debugDesktopEnvironment
    width: parent.width
    height: 150
    anchors.top: parent.top
    anchors.left: parent.left; anchors.right: parent.right
    anchors.margins: 2
    border.color: "white"
    color: "transparent"
    Repeater {
      model: [
        'menuOpen: ' + DesktopEnvironment.menuOpen,
        'menuBarMenu: ' + overlayLoader.menuBarMenu,
        '  - focusedItemIndex: ' + (overlayLoader.menuBarMenu ? overlayLoader.menuBarMenu.focusedItemIndex : 'none'),
        'overlayLoader.menus: ' + overlayLoader.menus,
        '  - length: ' + overlayLoader.menus.length,
        '  - last menu: ' + ((overlayLoader.menus.length > 0) ? overlayLoader.menus[overlayLoader.menus.length - 1].title : 'none'),
        'applicationMenu',
        '  - opened: ' + DesktopEnvironment.menus.applicationMenu.opened
      ]
      Text {
        y: index * 16
        text: modelData
        color: "white"
      }
    }
  }
  Rectangle {
    id: _debugOverlay
    width: parent.width
    height: 150
    anchors.top: _debugDesktopEnvironment.bottom
    anchors.left: parent.left; anchors.right: parent.right
    anchors.margins: 2
    border.color: "red"
    color: "transparent"
    Repeater {
      model: [
        'overlay.visible: ' + (DesktopEnvironment.overlay ? DesktopEnvironment.overlay.visible : ''),
        'overlay item: ' + (DesktopEnvironment.overlay ? DesktopEnvironment.overlay.overlayItemLoader.item : '')
      ]
      Text {
        y: index * 16
        text: modelData
        color: "white"
      }
    }
    Repeater {
      model: (DesktopEnvironment.menuOpen && DesktopEnvironment.overlay.overlayItemLoader.item
              ? DesktopEnvironment.overlay.overlayItemLoader.item.count
              : 0)
      Text {
        y: (50) + (index * 16)
        text: DesktopEnvironment.overlay.overlayItemLoader.item.itemAt(index).menu.title
        color: "white"
      }
    }
  }
}
