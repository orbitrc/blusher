import QtQuick 2.12

import "DesktopEnvironment"

QtObject {
  id: root
  enum MenuType {
    MenuBarMenu = 0,
    ContextualMenu = 1,
    Submenu = 2
  }

  // Menu delegates are completed before menu completed.
  // So, emit signal when the menu is really done.
  signal ready();

  default property list<QtObject> initialItems

  //=========================
  // Public Properties
  //=========================
  property int type
  property string title: ""
  property var items: []
  property var supermenu: null

  //=========================
  // Public Properties (Read-only for external)
  //=========================
  property int focusedItemIndex: -1
  readonly property alias opened: _private.opened
  readonly property string path: '/'

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
    root.ready();
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
    root.items.push(menuItem);
    menuItem.parentMenu = root;
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
