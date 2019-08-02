import QtQuick 2.12

QtObject {
  id: root

  //=========================
  // Public Properties
  //=========================
  property string title: ""
  property Image image: null
  property bool separator: false
  property Menu submenu: null
  property Menu parentMenu: null
  property var action: null
  property int shortcut: 0
  property bool checked: false

  //=========================
  // Public Properties (Read-only for external)
  //=========================
  property bool submenuOpened: false

  //=========================
  // Binding properties
  //------------------------
  // These properties will be binded after created by parent object.
  // Do not change manually!
  //=========================
  property bool focused: false

  //=======================
  // Created
  //=======================
  Component.onCompleted: {
  }

  //=======================
  // Property changed
  //=======================
  onParentMenuChanged: {
    if (root.parentMenu === null) {
      return;
    }

    if (root.hasSubmenu()) {
      root.submenu.supermenu = root.parentMenu;
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
}
