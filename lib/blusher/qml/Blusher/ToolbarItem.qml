import QtQuick 2.12

Rectangle {
  id: root

  property string label: ""

  color: "lightgreen"

  implicitWidth: _label.implicitWidth

  Text {
    id: _label
    text: root.label
    visible: (root.parent.displayMode !== Toolbar.DisplayMode.IconOnly)
    anchors.bottom: parent.bottom
  }
}
