import QtQuick 2.12

import Blusher 0.1

import "DesktopEnvironment"

View {
  id: root

  //=========================
  // Public Properties
  //=========================
  property string text: ""
  //  property string fontFamily: ''
  property bool selectable: false
  property Menu menu: Menu {
    title: 'Text Contextual'
    type: Menu.MenuType.ContextualMenu
    MenuItem {
      title: 'Copy'
      onTriggered: {
        Blusher.copyTextToClipboard(_text.selectedText);
      }
    }
    MenuItem {
      separator: true
    }
    MenuItem {
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
      leftPadding: 4 * (root.window ? root.window.screenScale : 1)
      rightPadding: 4 * (root.window ? root.window.screenScale : 1)
      font.pixelSize: root.fontSize * (root.window ? root.window.screenScale : 1)
      color: root.fontColor
      selectionColor: "lightblue"

      selectByMouse: root.selectable
      cursorPosition: 0

      MouseArea {
        width: _text.implicitWidth
        height: _text.implicitHeight

        acceptedButtons: root.selectable ? Qt.RightButton : Qt.NoButton

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
