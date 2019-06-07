import QtQuick 2.12

Item {
  id: root

  property string label: ""
  anchors.fill: parent

  Text {
    text: root.label
    visible: (root.parent.displayMode !== Toolbar.DisplayMode.IconOnly)
    anchors.bottom: parent.bottom
  }
}
