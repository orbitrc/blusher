import QtQuick 2.12

import Blusher 0.1

View {
  id: root

  property Menu2 menu: null
  property bool active: false

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
          onClicked: {
            if (modelData.submenu !== null) {
              modelData.submenu.open();
            }
          }
        }
      }
    }
  }
}
