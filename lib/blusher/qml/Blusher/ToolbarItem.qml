import QtQuick 2.12

import "DesktopEnvironment"

Rectangle {
  id: root

  property string label: ""

  color: "lightgreen"

  implicitWidth: _label.implicitWidth

  Text {
    id: _label
    text: root.label
    font.pixelSize: 12 * DesktopEnvironment.pixelsPerDp
    visible: (root.parent.displayMode !== Toolbar.DisplayMode.IconOnly)
    anchors.bottom: parent.bottom
  }
}
