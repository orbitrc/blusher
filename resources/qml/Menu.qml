import QtQuick 2.12

import Blusher 0.1 as Blusher

Blusher.View {
  id: root

  property Blusher.Menu menu: null

  width: 150
  height: 200

  Rectangle {
    anchors.fill: parent

    color: (root.menu === null) ? "red" : "grey"

    Flow {
      flow: Flow.TopToBottom
      Repeater {
        model: (root.menu === null) ? 0 : root.menu.items.length

        MenuItem {
          menuItem: root.menu.items[index]

          width: root.width
        }
      }
    }
  }
}
