import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQml.Models 2.12

Rectangle {
  id: root
  enum MenuType {
    MenuBarMenu,
    ContextualMenu,
    Submenu
  }

  //=========================
  // Public Properties
  //=========================
  property int type
  property string title: ""

  //=========================
  // Public Properties (Read-only for external)
  //=========================
  property int focusedItemIndex: -1
  property alias items: itemsModel.children

  visible: false

  color: "#eeedeb"
  border.width: 0

  ObjectModel {
    id: itemsModel
  }

  // For menu bar menu
  Component {
    id: menuBarMenu
    RowLayout {
      id: itemsView
      spacing: 0
      Repeater {
        model: itemsModel
      }

      Component.onCompleted: {
        root.visible = true

        // children[0] will always menuLoader.
        while (root.children.length > 1) {
          const menuItem = root.children[1]
          itemsModel.append(menuItem)
          menuItem.parent = itemsView
          menuItem.parentMenu = root
          menuItem.Layout.minimumWidth = 20
          bindMenuItem(menuItem)
        }
      }
    }
  }

  // For submenu
  Component {
    id: floatingMenu
    Window {
      id: _submenu

      visible: false

      flags: Qt.Popup
      width: 100
      height: 100

      property alias itemsView: itemsView

      MouseArea {
        anchors.fill: parent
        onClicked: {
          print(parent.parent)
        }
      }

      ColumnLayout {
        id: itemsView
        spacing: 0
        Repeater {
          model: itemsModel
        }
      }

      Component.onCompleted: {
        // children[0] will always menuLoader.
        while (root.children.length > 1) {
          const menuItem = root.children[1]
          itemsModel.append(menuItem)
          menuItem.parent = itemsView
          menuItem.parentMenu = root
          menuItem.Layout.minimumWidth = 20
          bindMenuItem(menuItem)
        }
      }
    }
  }

  Loader {
    id: menuLoader
    onLoaded: {
    }
  }


  //============
  // Created
  //============
  Component.onCompleted: {
    if (root.type === Menu.MenuType.MenuBarMenu) {
      menuLoader.sourceComponent = menuBarMenu
    } else {
      menuLoader.sourceComponent = floatingMenu
    }
  }

  //==============
  // Methods
  //==============
  function bindMenuItem(item) {
    item.focusedIn.connect(function() {
      root.focusedItemIndex = item.ObjectModel.index
    })
    item.focusedOut.connect(function() {
      root.focusedItemIndex = -1
    })
    item.focused = Qt.binding(() => (item.ObjectModel.index === root.focusedItemIndex))
  }

  function open() {
    if (root.type !== Menu.MenuType.MenuBarMenu) {
      menuLoader.item.x = MyWindow.window.x
      menuLoader.item.y = MyWindow.window.y + 30  // Menu bar height
      menuLoader.item.visible = true
    }
  }

  function close() {
    if (root.type !== Menu.MenuType.MenuBarMenu) {
      menuLoader.item.visible = false
    }
  }


  //=========
  // Debug
  //=========
  onFocusedItemIndexChanged: {
    print("now focusing: " + root.focusedItemIndex)
//    if (root.items[root.focusedItemIndex].hasSubmenu()) {
//      print('has submenu')
//    }
  }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
