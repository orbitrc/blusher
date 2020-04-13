import QtQuick 2.12
import QtQml.Models 2.12

ListElement {
  id: root

  //=========================
  // Public Properties
  //=========================
  property string title: ""
  property Image image: null
  property bool separator: false
  property Menu1 submenu: null
  property Menu1 parentMenu: null
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
