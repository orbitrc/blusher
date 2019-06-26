import QtQuick 2.12
import QtQml.Models 2.12

ListElement {
  id: root

  //=========================
  // Public Properties
  //=========================
  property string title: ""
  property bool separator: false
  property Menu submenu: null
  property Menu parentMenu: null
  property var action: null

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
