import QtQuick 2.12

import "DesktopEnvironment"

Rectangle {
  id: root
  width: 100
  height: 30

  property string text: ""
  property alias font: _font

  //=========================
  // Private Properties
  //=========================
  QtObject {
    id: _font
    property real size: 14
    property alias family: _input.font.family
    property alias pixelSize: _input.font.pixelSize
    property alias pointSize: _input.font.pointSize
  }

  border.color: "black"
  clip: true
  radius: 3

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.IBeamCursor
  }

  TextInput {
    id: _input
    anchors.fill: parent
    verticalAlignment: TextInput.AlignVCenter
    leftPadding: 4
    rightPadding: 4
    text: root.text
    font.pixelSize: root.font.size * DesktopEnvironment.pixelsPerDp
  }
}
