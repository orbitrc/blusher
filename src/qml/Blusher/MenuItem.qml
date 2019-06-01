import QtQuick 2.12

Item {
  id: root

  //=========================
  // Public Properties
  //=========================
  property string title: ""
  property bool separator: false
  property Menu submenu: null
  property Menu parentMenu: null

  //=========================
  // Public Properties (Read-only for external)
  //=========================
  property bool submenuOpened: false
  property alias mouseArea: mouseArea

  //=========================
  // Binding properties
  //------------------------
  // These properties will be binded after created by parent object.
  // Do not change manually!
  //=========================
  property bool focused: false

  signal focusedIn()
  signal focusedOut()

  implicitWidth: _text.implicitWidth
  height: 30

  Rectangle {
    id: _styler
    visible: (root.focused)
    anchors.fill: parent
    anchors.margins: 2
    border.width: 0
    color: "#bbb4b1"
    radius: 3
  }

  Text {
    id: _text
    text: parent.title
    anchors.verticalCenter: parent.verticalCenter
    rightPadding: 7.0   // 5.0 + styler's margin
    leftPadding: 7.0    // 5.0 + styler's margin
  }

  MouseArea {
    id: mouseArea

    anchors.fill: parent
    hoverEnabled: true

    onClicked: {
      (!root.focused) ? root.focusedIn() : root.focusedOut()
    }
    onEntered: {
      if (!root.isMenuBarMenuItem()) {
        root.focusedIn()
      } else {
        (root.parentMenu.focusedItemIndex > -1) ? root.focusedIn() : null
      }
    }
    onExited: {
      if (!root.isMenuBarMenuItem()) {
        root.focusedOut()
      }
    }
  }

  //=======================
  // Created
  //=======================
  Component.onCompleted: {
    // Set submenu's parent this.
    if (root.submenu !== null) {
      root.submenu.parent = root
    }
  }

  //=======================
  // Methods
  //=======================
  function isMenuBarMenuItem() {
    if (root.parentMenu && root.parentMenu.type === Menu.MenuType.MenuBarMenu) {
      return true
    }
    return false
  }

  function hasSubmenu() {
    return (root.submenu !== null)
  }

  //=======================
  // Property changed
  //=======================
  onFocusedChanged: {
    if (root.focused) {
      (root.hasSubmenu()) ? root.submenu.open() : null
    } else {
      (root.hasSubmenu()) ? root.submenu.close() : null
    }
  }
}
