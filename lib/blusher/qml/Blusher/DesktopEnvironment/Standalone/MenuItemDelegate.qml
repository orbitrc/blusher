import QtQuick 2.12
import QtQuick.Layouts 1.12

import ".."
import "../.."

Item {
  id: root

  property var menuItem: null
  property bool focused: false

  signal clicked(var mouse)
  signal entered()

  implicitWidth: _checked.width + _text.implicitWidth + _info.width
  height: 30 * DesktopEnvironment.pixelsPerDp

  Layout.fillWidth: true  // Fill when pop-up menu item.

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true

    MenuItemStyler {
      anchors.fill: parent
      visible: root.focused
    }
    Item {
      id: _checked

      visible: (root.menuItem.checked !== undefined ? root.menuItem.checked : false)
      anchors.verticalCenter: parent.verticalCenter
      anchors.left: parent.left
      anchors.leftMargin: 3 * DesktopEnvironment.pixelsPerDp
      height: 24 * DesktopEnvironment.pixelsPerDp
      width: 24 * DesktopEnvironment.pixelsPerDp
      children: [
        DesktopEnvironment.icons.checked,
        this.graphicalDebugRect
      ]
      property Rectangle graphicalDebugRect: Rectangle {
        visible: true
        anchors.fill: parent
        color: "#44ff0000"
      }
    }
    Text {
      id: _text
      text: (!root.menuItem.separator) ? root.menuItem.title : ' '
      anchors.verticalCenter: parent.verticalCenter
      leftPadding: 7.0 + _checked.width   // 5.0 + styler's margin + checked-image width
      rightPadding: 7.0       // 5.0 + styler's margin
      font.pixelSize: 14 * DesktopEnvironment.pixelsPerDp
    }
    Item {
      id: _info

      width: (this.shortcutText.text !== '' ? this.shortcutText.implicitWidth : 24)
      height: 24 * DesktopEnvironment.pixelsPerDp
      anchors.verticalCenter: parent.verticalCenter
      anchors.right: parent.right
      anchors.rightMargin: 3 * DesktopEnvironment.pixelsPerDp
      Rectangle {
        visible: true
        anchors.fill: parent
        color: "#44ff0000"
      }

      Component.onCompleted: {
        if (this.shortcutText.text !== '') {
          this.children.push(this.shortcutText);
        }
        if (root.menuItem.path[root.menuItem.path.length - 1] === '/') {
          this.children.push(DesktopEnvironment.icons.goNext);
        }
      }
      property Text shortcutText: Text {
        text: DesktopEnvironment.shortcutToString(root.menuItem.shortcut)
        font.pixelSize: 14 * DesktopEnvironment.pixelsPerDp
      }
    }

    Item {
      id: _separator
      visible: false
      height: 2 * DesktopEnvironment.pixelsPerDp
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.verticalCenter: parent.verticalCenter
      Rectangle {
        height: 1 * DesktopEnvironment.pixelsPerDp
        anchors.left: parent.left; anchors.right: parent.right;
        anchors.top: parent.top
        border.width: 0
        gradient: Gradient {
          orientation: Gradient.Horizontal
          GradientStop { position: 0.0; color: "#00000000"; }
          GradientStop { position: 0.5; color: "grey"; }
          GradientStop { position: 1.0; color: "#00000000"; }
        }
      }
      Rectangle {
        height: 1 * DesktopEnvironment.pixelsPerDp
        anchors.left: parent.left; anchors.right: parent.right;
        anchors.bottom: parent.bottom
        border.width: 0
        gradient: Gradient {
          orientation: Gradient.Horizontal
          GradientStop { position: 0.0; color: "#00000000"; }
          GradientStop { position: 0.5; color: "#ffffff"; }
          GradientStop { position: 1.0; color: "#00000000"; }
        }
      }
    }

    onClicked: {
      root.clicked(mouse);
    }

    onEntered: {
      root.entered();
    }
    onExited: {
      // If submenu is opened, don't take focus of this item.
      if (root.menuItem.path.endsWith('/')) {
        return;
      }
//      root.menuItem.parentMenu.focusItem(-1);
    }
  } // MouseArea

  Component.onCompleted: {
    if (root.menuItem.separator) {
      this.Layout.maximumHeight = 10;
      _separator.visible = true
    }
  }

  function trigger() {
    if (root.menuItem.action) {
      root.menuItem.action();
    }
    DesktopEnvironment.menuItemTriggered(root.menuItem.path);
  }

  function _menuBarMenuItemClicked(index) {
    if (root.menuItem.parentMenu.focusedItemIndex > -1) {
      // Menu bar menu already activated.
      root.menuItem.parentMenu.focusItem(-1);
      DesktopEnvironment.menuClosed()
    } else {
      // Menu bar menu not activated before.
      root.menuItem.parentMenu.focusItem(index);
      if (root.menuItem.hasSubmenu()) {
        root.menuItem.submenu.open(Window.window.contentItem)
      }
    }
  }

  function _menuBarMenuItemEntered(index) {
    // Do nothing if same index.
    if (root.menuItem.parentMenu.focusedItemIndex === index) {
      return;
    }

    // Menu bar menu already activated.
    if (root.menuItem.parentMenu.focusedItemIndex > -1 ||
        DesktopEnvironment.menus.applicationMenu.opened) {
      root.menuItem.parentMenu.focusItem(index);
      if (root.menuItem.hasSubmenu()) {
        root.menuItem.submenu.open(Window.window.contentItem)
      }
    }
  }

  function _menuBarMenuItemExited(index) {
    // Prevent menu bar menu losing focus.
    if (root.menuItem.parentMenu.focusedItemIndex > -1) {
      return;
    }
  }
}
