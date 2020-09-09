import QtQuick 2.12

import Blusher 0.1 as Blusher

Blusher.View {
  id: root

  property Blusher.MenuItem menuItem

  readonly property int separatorHeight: 4
  readonly property string separatorColor: "#d8d8d8"

  height: (!root.menuItem.separator) ? 20 : 12

  Rectangle {
    id: rootRect
    anchors.fill: parent
    color: "cyan"
    Rectangle {
      id: separatorBar

      visible: root.menuItem.separator

      anchors.centerIn: parent
      width: parent.width
      height: root.separatorHeight

      color: root.separatorColor
    }
  }
  Text {
    visible: !root.menuItem.separator
    text: menuItem.title
    font.pixelSize: 16
  }
}
