import QtQuick 2.12
import QtQuick.Window 2.12 as QtQuickWindow

import ".."       // Blusher.DesktopEnvironment
import "../.."    // Blusher

QtQuickWindow.Window {
  id: root

  property alias overlayItemLoader: overlayItemLoader

  property int mouseX: 0
  property int mouseY: 0

  property var menus: []
  property Menu menuBarMenu

  property alias menuBarLoader: menuBarLoader

  visible: true
  flags: Qt.Popup
  color: "#55000000" // "#00000000"

  MouseArea {
    id: _mouseArea

    anchors.fill: parent
    hoverEnabled: true

    onClicked: {
      DesktopEnvironment.menuClosed();
    }
    onEntered: {
      root.mouseX = this.mouseX;
      root.mouseY = this.mouseY;
      if (root.menus.length > 0) {
        root.renderMenus();
      }
    }

    Loader {
      id: menuBarLoader

      onLoaded: {
        root.menuBarMenu = DesktopEnvironment.app.mainMenu;
      }
    }

    Loader {
      id: overlayItemLoader
    }

    Loader {
      id: popUpLoader
    }

    FocusScope {
      focus: true

      Keys.onPressed: {
        let lastMenu = null;

        switch (event.key) {
        case Qt.Key_Escape:
          if (DesktopEnvironment.menuOpen) {
            DesktopEnvironment.menuClosed();
          }
          break;

        case Qt.Key_Down:
          if (DesktopEnvironment.menuOpen) {
            lastMenu = root.menus[root.menus.length - 1];
            if (lastMenu.focusedItemIndex === -1) {
              lastMenu.focusFirstItem();
            } else {
              lastMenu.focusNextItem();
            }
          }
          break;

        case Qt.Key_Up:
          if (DesktopEnvironment.menuOpen) {
            lastMenu = root.menus[root.menus.length - 1];
            if (lastMenu.focusedItemIndex === -1) {
              lastMenu.focusLastItem();
            } else {
              lastMenu.focusPreviousItem();
            }
          }
          break;

        case Qt.Key_Right:
          break;

        default:
          break;
        }
      }
    }
  }

  onVisibleChanged: {
    if (root.visible === false) {
      menuBarLoader.sourceComponent = undefined;
    }
  }

  Component.onCompleted: {
    print('DesktopEnvironment.Standalone.Overlay.onCompleted]');
    root.requestActivate();

    // Make overlay cover whole screen.
    this.width = QtQuickWindow.Screen.width * 3;
    this.height = QtQuickWindow.Screen.height;
  }

  function activateMenuBar() {
    if (menuBarLoader.sourceComponent !== undefined) {
      menuBarLoader.sourceComponent = undefined;
    }
    menuBarLoader.sourceComponent = DesktopEnvironment.menuDelegate;
    print(menuBarLoader);
    menuBarLoader.x = DesktopEnvironment.app.activeWindow.x;
    menuBarLoader.y = DesktopEnvironment.app.activeWindow.y;
    menuBarLoader.item.popUpMenuBar = true;
    menuBarLoader.item.menu = root.menuBarMenu;
  }

  function renderMenus() {
    print('renderMenus. mouseX: ' + root.mouseX);
  }
}
