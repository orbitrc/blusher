import QtQuick 2.12
import QtGraphicalEffects 1.0

import Blusher 0.1
import "DesktopEnvironment"

View {
  id: root

  enum ButtonType {
    PushButton,
    RadioButton
  }

  property string title: ""
  signal clicked(var mouse)
  //==============
  // State
  //==============
  property bool active: false
  property bool hover: false

  //===============
  // Size/Position
  //===============
  property rect rect: Qt.rect(0, 0, 100, 34)
  property rect pos: Qt.rect(0, 0, 0, 0)

  width: 100
  height: 34
  x: 0
  y: 0

//  color: "transparent"
//  border.width: 0
  MouseArea {
    id: mouseArea
    anchors.fill: parent

    onPressed: {
      root.active = true
    }
    onReleased: {
      root.active = false
    }
    onEntered: {
      root.active = true
    }

    onExited: {
      root.active = false
    }

    onClicked: {
      root.clicked(mouse)
    }
  }

  Rectangle {
    id: _borderOut

    anchors.fill: parent
    color: "#9d9795"
    border.width: 0
    radius: 5 * (root.window ? root.window.screenScale : 1)
    Rectangle {
      id: _styler

      anchors.fill: parent
      anchors.rightMargin: 1 * (root.window ? root.window.screenScale : 1)
      anchors.leftMargin: 1 * (root.window ? root.window.screenScale : 1)
      anchors.bottomMargin: 1 * (root.window ? root.window.screenScale : 1)
      anchors.topMargin: 1 * (root.window ? root.window.screenScale : 1)
      // Inner border
      border.width: 1 * (root.window ? root.window.screenScale : 1)
      border.color: "#f7f6f6"

      radius: 5 * (root.window ? root.window.screenScale : 1)
      LinearGradient {
        anchors.fill: parent
        gradient: Gradient {
          GradientStop { position: 0.0; color: "#f0efee" }
          GradientStop { position: 1.0; color: "#d6d1ce" }
        }
        source: parent
        visible: (root.active !== true)
      }
    }
  }

  Text {
    id: _text
    text: root.title
    font.pixelSize: 13 * (root.window ? root.window.screenScale : 1)
    font.family: "Liberation Sans"
    anchors.centerIn: root
  }

  Rectangle {
    id: graphicalDebugRect
    visible: false
    anchors.fill: parent
    color: "#33ff0000"
  }
}
