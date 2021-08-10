import QtQml 2.12
import QtQuick 2.12

import Blusher 0.1

BaseWindow {
  id: root

  default property alias bodyItems: body.data

  readonly property alias body: body

  color: '#d6d1ce'

  MenuBar {
    id: menuBar
    menu: root.menu
    visible: root.hasMenuBar()

    width: root.width
  }

  View {
    id: body

    x: 0
    y: root.hasMenuBar() ? 30 : 0
    width: root.width
    height: root.height - (root.hasMenuBar() ? 30 : 0)
  }

  onKeyPressed: {
    print(event.modifiers);
  }

  function hasMenuBar() {
    return root.menu !== null;
  }
}
