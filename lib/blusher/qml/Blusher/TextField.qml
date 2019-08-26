import QtQuick 2.12

import "DesktopEnvironment"

Rectangle {
  id: root
  //===============
  // Size/Position
  //===============
  property rect rect: Qt.rect(0, 0, 100, 30)
  property rect pos: Qt.rect(0, 0, 0, 0)

  width: rect.width * DesktopEnvironment.pixelsPerDp
  height: rect.height * DesktopEnvironment.pixelsPerDp
  x: pos.x * DesktopEnvironment.pixelsPerDp
  y: pos.y * DesktopEnvironment.pixelsPerDp

  //=========================
  // Public Properties
  //=========================
  property alias text: _input.text
  property alias font: _font
  property string fontFamily: 'Liberation Sans'
  property real fontSize: 14
  property Menu menu: DesktopEnvironment.menus.textEditMenu

  //=========================
  // Private Properties
  //=========================
  QtObject {
    id: _font
    property real size: root.fontSize
    property alias family: root.fontFamily
    property alias pixelSize: _input.font.pixelSize
    property alias pointSize: _input.font.pointSize
  }

  border.color: "black"
  clip: true
  radius: 3

  TextInput {
    id: _input

//    text: root.text

    anchors.fill: parent
    verticalAlignment: TextInput.AlignVCenter
    leftPadding: 4
    rightPadding: 4
    font.pixelSize: root.font.size * DesktopEnvironment.pixelsPerDp
    font.family: root.font.family
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
