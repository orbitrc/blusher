import QtQuick 2.12

import Blusher 0.1

import "DesktopEnvironment"

View {
  id: root

  //=========================
  // Public Properties
  //=========================
  property string text: ""
  property alias font: _font
  //  property string fontFamily: ''
  property bool selectable: false
  property Menu2 menu: Menu2 {
    title: 'Text Contextual'
    type: Menu2.MenuType.ContextualMenu
    MenuItem2 {
      title: 'Copy'
      onTriggered: {
        Blusher.copyTextToClipboard(_text.selectedText);
      }
    }
    MenuItem2 {
      separator: true
    }
    MenuItem2 {
      title: 'Select All'
    }
  }

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

  width: root.implicitWidth
  height: 30

  Rectangle {
    id: rectangle

    anchors.fill: parent
    color: root.backgroundColor

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
      cursorPosition: 0

      MouseArea {
        width: _text.implicitWidth
        height: _text.implicitHeight

        acceptedButtons: Qt.RightButton

        cursorShape: (root.selectable ? Qt.IBeamCursor : Qt.ArrowCursor)
        propagateComposedEvents: true

        onClicked: {
          if (mouse.button === Qt.LeftButton) {
            mouse.accepted = true;
          } else if (mouse.button === Qt.RightButton) {
            let pos = mapToGlobal(mouse.x, mouse.y);
            root.menu.open(pos.x, pos.y + 1);
            print(_text.selectedText);
            print(_text.selectionStart + '-' + _text.selectionEnd);
            print(_text.text.length);
          }
        }
      }
    }
  }
}
