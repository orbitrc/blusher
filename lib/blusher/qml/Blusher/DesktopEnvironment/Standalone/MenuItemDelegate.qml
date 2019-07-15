import QtQuick 2.12
import QtQuick.Layouts 1.12

import ".."
import "../.."

Item {
  id: root

  property MenuItem menuItem: null

  implicitWidth: _text.implicitWidth
  height: 30

  Layout.fillWidth: true  // Fill when pop-up menu item.

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true

    MenuItemStyler {
      anchors.fill: parent
      visible: root.menuItem.focused
    }
    Text {
      id: _text
      text: root.menuItem.title
      anchors.verticalCenter: parent.verticalCenter
      rightPadding: 7.0   // 5.0 + styler's margin
      leftPadding: 7.0    // 5.0 + styler's margin
      font.pointSize: 14 * DesktopEnvironment.pixelsPerDp
    }
    Item {
      id: _separator
      visible: false
      height: 2
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.verticalCenter: parent.verticalCenter
      Rectangle {
        height: 1
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
        height: 1
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
      // If menu bar menu.
      if (root.menuItem.isMenuBarMenuItem()) {
        root._menuBarMenuItemClicked(index);
      }
      // If regular menu.
      if (!root.menuItem.isMenuBarMenuItem()) {
        if (!root.menuItem.hasSubmenu()) {
          print('MenuItem.action')
        }
        if (root.menuItem.action !== null) {
          root.menuItem.action();
        }
      }
    }

    onEntered: {
      if (root.menuItem.isMenuBarMenuItem()) {
        root._menuBarMenuItemEntered(index);
      } else {
        if (root.menuItem.separator) {
          root.menuItem.parentMenu.focusItem(-1);
        } else {
          root.menuItem.parentMenu.focusItem(index);
        }
        if (root.menuItem.hasSubmenu() && !root.menuItem.submenu.opened) {
          root.menuItem.submenu.open(parent)
        }
      }
    }
    onExited: {
      if (root.menuItem.isMenuBarMenuItem()) {
        root._menuBarMenuItemExited();
      } else {
        // If submenu is opened, don't take focus of this item.
        if (root.menuItem.hasSubmenu() && root.menuItem.submenu.opened) {
          return;
        }
        root.menuItem.parentMenu.focusItem(-1);
      }
    }
  } // MouseArea

  Component.onCompleted: {
    if (root.menuItem.separator) {
      this.Layout.maximumHeight = 10;
      _separator.visible = true
    }
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
