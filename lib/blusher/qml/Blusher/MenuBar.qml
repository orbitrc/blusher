import QtQuick 2.12

import Blusher 0.1

View {
  id: root

  property Menu2 menu: null
  property bool active: false
  property int focusedItemIndex: -1

  height: 30

  Rectangle {
    anchors.fill: parent
    color: "gray"

    Row {
      Repeater {
      model: root.menu.items
        Item {
        id: menuItem

        width: menuItemText.implicitWidth
        height: root.height
        x: this.width * index
        Rectangle {
          visible: root.focusedItemIndex === index
          color: "red"
          anchors.fill: parent
        }

        Text {
          id: menuItemText
          text: modelData.title
        }
        MouseArea {
          anchors.fill: parent
          hoverEnabled: root.active
          onClicked: {
            if (!root.active) {
              root.active = true;
              // Open submenu if exists.
              if (modelData.submenu !== null) {
                menuItem.openMenu();
              }
            } else {
              root.active = false;
            }
          }
          onEntered: {
            if (!root.active) {
              return;
            }
//            print(modelData.title + ' entered');
            menuItem.openMenu();
          }
        }
        function openMenu() {
          let globalPos = root.mapToGlobal(0, 0);
          Blusher.app.setMenuBarRect(Qt.rect(
            globalPos.x, globalPos.y, root.width, root.height));
          let globalMenuItemPos = menuItem.mapToGlobal(0, 0);
          Blusher.app.setMenuBarMenuItemRect(Qt.rect(
            globalMenuItemPos.x, globalMenuItemPos.y, menuItem.width, menuItem.height));
          root.focusedItemIndex = index;
          modelData.submenu.open();
        }
      }
      }
    }
  }
  Connections {
    target: Blusher.app
    onMenuClosedByUser: {
      root.active = false;
      root.focusedItemIndex = -1;
    }
  }
}
