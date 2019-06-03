import QtQuick 2.12

Item {
  id: root

  //====================
  // Public Properties
  //====================
  property QtObject menuItem: null
  property string text: ""

  //====================
  // Signals
  //====================
  signal focusedIn()
  signal focusedOut()

  implicitWidth: _text.implicitWidth
  height: 30

  Rectangle {
    id: _styler
    visible: (root.menuItem.focused)
    anchors.fill: parent
    anchors.margins: 2
    border.width: 0
    color: "#bbb4b1"
    radius: 3
  }

  Text {
    id: _text
    text: root.text
    anchors.verticalCenter: parent.verticalCenter
    rightPadding: 7.0   // 5.0 + styler's margin
    leftPadding: 7.0    // 5.0 + styler's margin
  }

  MouseArea {
    id: mouseArea

    anchors.fill: parent
    hoverEnabled: true

    onClicked: {
      (!root.menuItem.focused) ? root.focusedIn() : root.focusedOut()
    }
    onEntered: {
      if (!root.menuItem.isMenuBarMenuItem()) {
        root.focusedIn()
      } else {
        (root.menuItem.parentMenu.focusedItemIndex > -1) ? root.focusedIn() : null
      }
    }
    onExited: {
      if (root.menuItem.isMenuBarMenuItem()) {
        return
      }
      if (root.hasSubmenu()) {
      }

      root.focusedOut()
    }
  }

  //=======================
  // Methods
  //=======================
  function hasSubmenu() {
    return menuItem.hasSubmenu()
  }
}
