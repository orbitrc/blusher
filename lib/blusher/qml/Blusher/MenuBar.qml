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

    Repeater {
      model: root.menu.items
      Item {
        width: menuItemText.implicitWidth
        height: root.height
        x: this.width * index
        Text {
          id: menuItemText
          text: modelData.title
        }
        MouseArea {
          anchors.fill: parent
          hoverEnabled: root.active
          onClicked: {
            if (modelData.submenu !== null) {
              root.active = true;
              modelData.submenu.open();
            }
          }
          onEntered: {
            print(modelData.title + ' entered');
//            modelData.submenu.open();
          }
        }
      }
    }
  }
}
