import QtQuick 2.12
import QtQuick.Layouts 1.12

Rectangle {
  id: root

  property Menu menu: null
  visible: false

  color: "#eeedeb"
  border.width: 0

  // For menu bar menu
  Component {
    id: menuBarMenu
    RowLayout {
      id: itemsView
      property alias menuItemViewList: menuItemViewList

      spacing: 0
      Repeater {
        model: root.menu
        id: menuItemViewList
        MenuItemView {
          menuItem: root.menu.items[index] // root.menu.get(index)
          text: title

          onFocusedIn: {
            root.menu.focusedItemIndex = index
          }
          onFocusedOut: {
            root.menu.focusedItemIndex = -1
          }

          Component.onCompleted: {
            Layout.minimumWidth = 20
            bindMenuItem(this.menuItem, index)
            print('[MenuItemView, "' + root.menu.title + '"] preferredWidth: ' + Layout.preferredWidth)
            print('[MenuItemView, "' + root.menu.title + '"] implicitWidth: ' + this.implicitWidth)
          }
        }
      }

      Component.onCompleted: {
        root.visible = true
      }
    }
  }


  // For submenu
  Component {
    id: floatingMenu
    Rectangle {
      id: menuView
      visible: false

//      flags: Qt.Popup
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
//          model: itemsModel
        }
      }

      Component.onCompleted: {
      }
    }
  }

  //=========
  // Debug
  //=========
  /*
  MouseArea {
    anchors.fill: parent
    onClicked: {
      print('DEBUG [MenuView.MouseArea] clicked')
    }
  }
  */

  Loader {
    id: menuLoader
  }

  //============
  // Created
  //============
  Component.onCompleted: {
    if (root.menu.type === Menu.MenuType.MenuBarMenu) {
      menuLoader.sourceComponent = menuBarMenu
      print('[MenuView, "' + root.menu.title + '" - onCompleted] menu.count: ' + root.menu.count)
    } else {
      menuLoader.sourceComponent = floatingMenu
    }
  }

  //==============
  // Methods
  //==============
  function bindMenuItem(item, index) {
    item.focused = Qt.binding(() => (index === root.menu.focusedItemIndex))
  }

  //=======================
  // Property changed
  //=======================
  onMenuChanged: {
    if (root.menu) {
      print('[MenuView, "' + root.menu.title + '" - onMenuChanged] menu: ' + root.menu)
    }
  }
}
