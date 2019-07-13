import QtQuick 2.12
import QtQml.Models 2.12

import Blusher.DesktopEnvironment 0.1

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
  property var supermenu: null

  //=========================
  // Public Properties (Read-only for external)
  //=========================
  property int focusedItemIndex: -1
  readonly property alias opened: _private.opened

  //=========================
  // Private Properties
  //=========================
  property QtObject _private: QtObject {
    id: _private
    property bool opened: false
  }


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
      return;
    }
    _private.opened = true
    DesktopEnvironment.menuOpened(view, root)
  }

  /// \brief  Close menu.
  function close() {
    if (root.type === Menu.MenuType.MenuBarMenu) {
      return;
    }
    root.focusItem(-1);
    _private.opened = false
  }

  /// \brief  Add menu item to this menu.
  /// \param  menuItem
  ///         Menu item to add.
  function addItem(menuItem) {
    root.append(menuItem)
    menuItem.parentMenu = root
  }

  function focusItem(index) {
    if (root.focusedItemIndex > -1) {
      root.items[root.focusedItemIndex].focused = false;
    }

    root.focusedItemIndex = index;

    if (index > -1) {
      root.items[root.focusedItemIndex].focused = true;
    }
  }

}
