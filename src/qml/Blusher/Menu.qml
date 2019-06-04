import QtQuick 2.12
import QtQml.Models 2.12

ListModel {
  id: root
  enum MenuType {
    MenuBarMenu,
    ContextualMenu,
    Submenu
  }

  default property list<ListElement> items

  //=========================
  // Public Properties
  //=========================
  property int type
  property string title: ""

  //=========================
  // Public Properties (Read-only for external)
  //=========================
  property int focusedItemIndex: -1

  //==============
  // Created
  //==============
  Component.onCompleted: {
    for (let i = 0; i < root.items.length; ++i) {
      root.addItem(root.items[i])
    }
  }

  //==============
  // Methods
  //==============
  /// \brief  Open menu.
  /// \param  view
  ///         Visual item parent that menu view should be belowed.
  function open(view) {
    if (root.type === Menu.MenuType.MenuBarMenu) {
      return
    }
  }

  /// \brief  Close menu.
  function close() {
    if (root.type === Menu.MenuType.MenuBarMenu) {
      return
    }
    root.focusedItemIndex = -1
  }

  function addItem(menuItem) {
    root.append(menuItem)
    menuItem.parentMenu = root
  }


  //=========
  // Debug
  //=========
  onFocusedItemIndexChanged: {
  }
}
