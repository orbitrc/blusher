import QtQuick 2.12
import QtQuick.Window 2.12 as QtQuickWindow

import ".."       // Blusher.DesktopEnvironment
import "../.."    // Blusher

QtQuickWindow.Window {
  id: root

  property alias overlayItemLoader: overlayItemLoader

  property int mouseX: 0
  property int mouseY: 0

  property list<Menu> menus
  property Menu menuBarMenu

  visible: true
  flags: Qt.Popup
  color: "#11ff0000" // "#00000000"

  MouseArea {
    id: _mouseArea

    anchors.fill: parent
    hoverEnabled: true

    onClicked: {
      DesktopEnvironment.menuClosed()
    }
    onEntered: {
      root.mouseX = this.mouseX;
      root.mouseY = this.mouseY;
      if (root.menus.length > 0) {
        root.renderMenus();
      }
    }

    MouseArea {
      id: _menuBarArea
      hoverEnabled: true
      propagateComposedEvents: true
      height: 30

      Loader {
        id: _menuBarLoader

        onLoaded: {
          root.menuBarMenu = DesktopEnvironment.parent.Window.window.menu;
        }
      }
    }

    Loader {
      id: overlayItemLoader
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

  Component.onCompleted: {
    print('DesktopEnvironment.Standalone.Overlay.onCompleted]');
    root.requestActivate();

    // Make overlay cover whole screen.
    this.width = QtQuickWindow.Screen.width * 3;
    this.height = QtQuickWindow.Screen.height;

    _menuBarArea.x = DesktopEnvironment.parent.Window.window.x
    _menuBarArea.y = DesktopEnvironment.parent.Window.window.y
    _menuBarArea.width = DesktopEnvironment.parent.Window.window.width

    if (_menuBarLoader.sourceComponent !== undefined) {
      _menuBarLoader.sourceComponent = undefined;
    }
    _menuBarLoader.sourceComponent = DesktopEnvironment.menuDelegate;
    _menuBarLoader.item.menu = root.menuBarMenu;
  }

  function renderMenus() {
    print('renderMenus. mouseX: ' + root.mouseX);
    overlayItemLoader.sourceComponent = undefined;
    overlayItemLoader.sourceComponent = menuViewComponent;
  }
}
