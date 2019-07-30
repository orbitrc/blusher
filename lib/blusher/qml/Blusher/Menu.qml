import QtQuick 2.12
import QtQml.Models 2.12

import "DesktopEnvironment"

ListModel {
  id: root
  enum MenuType {
    MenuBarMenu = 0,
    ContextualMenu = 1,
    Submenu = 2
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

    if (index > -1 && root.items[index].separator) {
      print('[Menu] WARNING: Focused item is separator!');
    }
  }

  function focusFirstItem() {
    root.focusItem(0);
  }

  function focusNextItem() {
    if (root.focusedItemIndex === -1) {
      return;
    }
    let idx = root.focusedItemIndex;
    if ((idx + 1) >= root.items.length) {
      return;
    }

    do {
      ++idx;
    } while (root.items[idx].separator)

    root.focusItem(idx);
  }

  function focusPreviousItem() {
    if (root.focusedItemIndex === -1) {
      return;
    }
    let idx = root.focusedItemIndex;
    if (idx === 0) {
      return;
    }

    do {
      --idx;
    } while (root.items[idx].separator)

    root.focusItem(idx);
  }

  function focusLastItem() {
    root.focusItem(root.items.length - 1);
  }

}
