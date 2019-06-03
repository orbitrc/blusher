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
  function open() {
    if (root.type === Menu.MenuType.MenuBarMenu) {
      return
    }
    print('[Menu, "' + root.title + '" - Menu.open()] window: ' + String(MyWindow.window))
//    DesktopEnvironment.menuOpened(MyWindow.window.contentItem, root)
  }

  function close() {
    if (root.type === Menu.MenuType.MenuBarMenu) {
      return
    }
  }

  function addItem(menuItem) {
    root.append(menuItem)
    menuItem.parentMenu = root
  }


  //=========
  // Debug
  //=========
  onFocusedItemIndexChanged: {
    print("[Menu, \"" + root.title + "\"] now focusing: " + root.focusedItemIndex)
//    if (root.items[root.focusedItemIndex].hasSubmenu()) {
//      print('has submenu')
//    }
  }
}
