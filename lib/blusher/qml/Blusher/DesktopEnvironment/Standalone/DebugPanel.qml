import QtQuick 2.12
import QtQuick.Window 2.12

import ".."       // Blusher.DesktopEnvironment

Window {
  id: root
  flags: Qt.Popup

  width: 300
  height: 600
  visible: true

  color: "#000000"
  opacity: 0.8

  Rectangle {
    id: _debugDesktopEnvironment
    width: parent.width
    height: 200
    anchors.top: parent.top
    anchors.left: parent.left; anchors.right: parent.right
    anchors.margins: 2
    border.color: "white"
    color: "transparent"
    Rectangle {
      anchors.right: parent.right
      width: 20
      height: 20
      MouseArea {
        anchors.fill: parent
        onClicked: {
          if (root.flags === Qt.Popup) {
            print('change to Qt.Window');
            root.flags = Qt.Window;
            root.visible = false;
            root.visible = true;
          } else {
            print('change to Qt.Popup');
            root.flags = Qt.Popup;
            root.visible = false;
            root.visible = true;
          }
        }
      }
    }

    Repeater {
      model: [
        'menuOpen: ' + DesktopEnvironment.menuOpen,
        'menuBarMenu: ' + root.getMenuBarMenu(),
        '  - focusedItemIndex: ' + (root.getMenuBarMenu() ? root.getMenuBarMenu().focusedItemIndex : 'none'),
        'overlay.menus: ' + root.getMenus(),
        '  - length: ' + root.getMenusLength(),
        '  - last menu: ' + ((root.getMenus() && root.getMenus().length > 0) ? root.getMenus()[root.getMenusLength() - 1].title : 'none'),
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
        font.pixelSize: 12
      }
    }
    Repeater {
      model: (DesktopEnvironment.menuOpen && DesktopEnvironment.overlay.overlayItemLoader.item
              ? DesktopEnvironment.overlay.overlayItemLoader.item.count
              : 0)
      Text {
        y: (50) + (index * 16)
        text: (DesktopEnvironment.overlay.overlayItemLoader.item.itemAt(index).menu.title
               + '(opened: ' + DesktopEnvironment.overlay.overlayItemLoader.item.itemAt(index).menu.opened
               + ', focusedItemIndex: ' + DesktopEnvironment.overlay.overlayItemLoader.item.itemAt(index).menu.focusedItemIndex
               + ')')
        color: "white"
        font.pixelSize: 12
      }
    }
  }

  function getMenus() {
    return (DesktopEnvironment.overlay ? DesktopEnvironment.overlay.menus : null);
  }
  function getMenusLength() {
    const menus = root.getMenus();
    return (menus ? menus.length : null);
  }
  function getMenuBarMenu() {
    return (DesktopEnvironment.overlay ? DesktopEnvironment.overlay.menuBarMenu : null);
  }
}
