import QtQml 2.12
import QtQuick 2.12 as QtQuick

import Blusher 0.1

BaseWindow {
  id: root

  default property alias bodyItems: body.children

  property string menu: ''

  MenuBar {
    id: menuBar
  }

  View {
    id: body

    x: 0
    y: root.hasMenuBar() ? 30 : 0
    width: root.width
    height: root.height - (root.hasMenuBar() ? 30 : 0)
  }

  function hasMenuBar() {
    return root.menu !== '';
  }
}
