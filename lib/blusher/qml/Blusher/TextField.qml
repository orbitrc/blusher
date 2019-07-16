import QtQuick 2.12

import "DesktopEnvironment"

Rectangle {
  id: root
  width: 100
  height: 30

  //=========================
  // Public Properties
  //=========================
  property string text: ""
  property alias font: _font
  property Menu menu: DesktopEnvironment.menus.textEditMenu

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

  TextInput {
    id: _input

    text: root.text

    anchors.fill: parent
    verticalAlignment: TextInput.AlignVCenter
    leftPadding: 4
    rightPadding: 4
    font.pixelSize: root.font.size * DesktopEnvironment.pixelsPerDp
    selectionColor: "lightblue"

    selectByMouse: true

    MouseArea {
      anchors.fill: parent

      acceptedButtons: Qt.RightButton

      cursorShape: Qt.IBeamCursor
      propagateComposedEvents: true

      onClicked: {
        root.menu.open(Window.window.contentItem);
      }
    }
  }
}
