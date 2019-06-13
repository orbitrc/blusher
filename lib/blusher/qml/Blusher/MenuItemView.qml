import QtQuick 2.12

import "DesktopEnvironment"

Item {
  id: root
  clip: true

  //====================
  // Public Properties
  //====================
  property MenuItem menuItem: null
  property string text: ""

  //=========================
  // Private Properties
  //=========================
  property QtObject _private: QtObject {
    id: _private
    property bool focused: (root.menuItem.focused)
    onFocusedChanged: {
      if (_private.focused === false) {
        // Close submenu if has and opened.
        if (root.hasSubmenu() && root.menuItem.submenu.opened) {
          root.menuItem.submenu.close()
        }
      }
    }
  }

  //====================
  // Signals
  //====================
  signal clicked()
  signal entered()
  signal exited()

  implicitWidth: _text.implicitWidth
  height: 30

  //===================
  // Items
  //===================
  Rectangle {
    id: _styler
    visible: _private.focused
    anchors.fill: parent
    anchors.margins: 2
    border.width: 0
    color: "#bbb4b1"
    radius: 3
  }

  Rectangle {
    id: _separator
    visible: false
    height: 3
    border.width: 0
    color: "#d3d3d3"
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
  }

  Text {
    id: _text
    text: root.text
    anchors.verticalCenter: parent.verticalCenter
    rightPadding: 7.0   // 5.0 + styler's margin
    leftPadding: 7.0    // 5.0 + styler's margin
    font.pointSize: 14 * DesktopEnvironment.pixelsPerDt
    font.bold: root.menuItem.isMenuBarMenuItem()
  }

  MouseArea {
    id: mouseArea

    anchors.fill: parent
    hoverEnabled: true

    onClicked: {
      root.clicked()
    }
    onEntered: {
      root.entered()
      if (root.menuItem.isMenuBarMenuItem()) {
        return
      }
      if (root.menuItem.hasSubmenu() && !root.menuItem.submenu.opened) {
        root.menuItem.submenu.open(parent)
      }
    }
    onExited: {
      // Prevent menu bar menu losing focus.
      if (root.menuItem.isMenuBarMenuItem()) {
        return
      }
      // If submenu is opened, don't take focus of this item.
      if (root.hasSubmenu() && root.menuItem.submenu.opened) {
        return
      }

      root.exited()
    }
  }

  //==================
  // Created
  //==================
  Component.onCompleted: {
    if (root.menuItem.separator) {
      root.height = 10
      _separator.visible = true
    }
  }

  //=======================
  // Methods
  //=======================
  function hasSubmenu() {
    return menuItem.hasSubmenu()
  }
}
