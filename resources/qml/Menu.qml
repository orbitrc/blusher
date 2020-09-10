import QtQuick 2.12

import Blusher 0.1 as Blusher

Blusher.View {
  id: root

  property Blusher.Menu menu: null

  width: 150
  height: menuHeight()

  Rectangle {
    anchors.fill: parent

    color: (root.menu === null) ? "red" : "#eaeaea"

    Flow {
      id: menuItems

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

  /// Calculate total menu height.
  function menuHeight() {
    // For prevent QWidget with 0x0 size, set default size.
    if (root.menu === null) {
      return 10;
    }

    let height = 0;
    for (let i = 0; i < menuItems.children.length; ++i) {
      height += menuItems.children[i].height;
    }
    if (height === 0) {
      return 10;
    }

    return height;
  }
}
