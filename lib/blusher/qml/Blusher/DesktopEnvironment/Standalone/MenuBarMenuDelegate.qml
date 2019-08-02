import QtQuick 2.12
import QtQuick.Layouts 1.12

import ".."       // Blusher.DesktopEnvironment
import "../.."    // Blusher
import "." as Standalone

Rectangle {
  id: root

  //===================
  // Public properties
  //===================
  property Menu menu: null
  property Menu applicationMenu: DesktopEnvironment.menus.applicationMenu

  //================
  // Style
  //================
  height: DesktopEnvironment.menuBarHeight * DesktopEnvironment.pixelsPerDp
  implicitWidth: itemsView.implicitWidth
  width: this.implicitWidth

  Rectangle {
    id: _styler
    anchors.fill: parent
    color: "#d6d2d0"
    border.width: 0
  }

  RowLayout {
    id: itemsView
    property alias menuItemViewList: menuItemViewList

    spacing: 0
    // Application menu
    Item {
      width: _text.implicitWidth
      Layout.alignment: Qt.AlignTop
      Layout.fillHeight: true
      MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
          if (root.menu.focusedItemIndex > -1 || root.applicationMenu.opened) {
            // Menu bar menu already activated.
            root.menu.focusItem(-1);
            DesktopEnvironment.menuClosed();
          } else {
            // Menu bar menu not activated before.
            root.applicationMenu.open(Window.window.contentItem);
          }
        }
        onEntered: {
          // Menu bar menu already activated.
          if (root.menu.focusedItemIndex > -1) {
            root.menu.focusItem(-1);
            root.applicationMenu.open(Window.window.contentItem);
          }
        }
        onExited: {
          if (root.menu.focusedItemIndex > -1 ||
              root.applicationMenu.opened) {
            return;
          }
        }

        Connections {
          target: root.menu
          onFocusedItemIndexChanged: {
            root.applicationMenu.close();
          }
        }

        MenuItemStyler {
          anchors.fill: parent
          visible: root.applicationMenu.opened
        }
        Text {
          id: _text

          text: DesktopEnvironment.app.name

          anchors.verticalCenter: parent.verticalCenter
          rightPadding: 7.0   // 5.0 + styler's margin
          leftPadding: 7.0    // 5.0 + styler's margin
          font.pixelSize: 14 * DesktopEnvironment.pixelsPerDp
          font.bold: true
        }
      }
    }
    // Menu items
    Repeater {
      model: root.menu.items
      id: menuItemViewList

      Standalone.MenuItemDelegate {
        menuItem: root.menu.items[index]
        Layout.minimumHeight: root.height
      }
    }
  }
}

