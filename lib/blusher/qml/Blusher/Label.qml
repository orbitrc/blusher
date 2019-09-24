import QtQuick 2.12

import "DesktopEnvironment"

Rectangle {
  id: root
  width: 100
  height: 30

  color: root.backgroundColor

  //=========================
  // Public Properties
  //=========================
  property string text: ""
  property alias font: _font
//  property string fontFamily: ''
  property bool selectable: false
  property Menu menu: DesktopEnvironment.menus.textEditMenu
  property alias fontSize: _font.size
  property alias fontColor: _font.color

  property string backgroundColor: "#00000000"

  property alias implicitWidth: _text.implicitWidth

  //=========================
  // Private Properties
  //=========================
  QtObject {
    id: _font
    property real size: 14
    property string color: "#000000"
    property alias family: _text.font.family
    property alias pixelSize: _text.font.pixelSize
    property alias pointSize: _text.font.pointSize
  }

  border.width: 0
  clip: true

  TextInput {
    id: _text

    text: root.text
    readOnly: true

    anchors.fill: parent
    verticalAlignment: TextInput.AlignVCenter
    leftPadding: 4
    rightPadding: 4
    font.pixelSize: root.font.size * DesktopEnvironment.pixelsPerDp
    color: root.font.color
    selectionColor: "lightblue"

    selectByMouse: root.selectable

    MouseArea {
      anchors.fill: parent

      acceptedButtons: Qt.LeftButton | Qt.RightButton

      cursorShape: (root.selectable ? Qt.IBeamCursor : Qt.ArrowCursor)
      propagateComposedEvents: true

      onClicked: {
        if (mouse.button === Qt.LeftButton) {
          mouse.accepted = true;
        } else if (mouse.button === Qt.RightButton) {
          root.menu.open(Window.window.contentItem);
          print(_text.selectedText);
          print(_text.selectionStart + '-' + _text.selectionEnd);
          print(_text.text.length);
        }
      }
    }
  }
}
