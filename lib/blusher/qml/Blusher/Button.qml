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
    id: _styler
    anchors.fill: parent
    color: "#808080"
    anchors.rightMargin: 2
    anchors.leftMargin: 2
    anchors.bottomMargin: 2
    anchors.topMargin: 2
    border.width: 0
    radius: 3
    LinearGradient {
      anchors.fill: parent
      gradient: Gradient {
        GradientStop { position: 0.0; color: "darkgrey" }
        GradientStop { position: 1.0; color: "white" }
      }
      source: parent
      visible: (root.active !== true)
    }
  }

  DropShadow {
    anchors.fill: _styler
    verticalOffset: 3
    radius: 2
    color: "#a9a9a9"
    source: _styler
  }

  Text {
    id: _text
    text: root.title
    font.pixelSize: 13 * DesktopEnvironment.pixelsPerDp
    font.family: "Liberation Sans"
    anchors.horizontalCenter: root.horizontalCenter
    anchors.verticalCenter: root.verticalCenter
  }

  Rectangle {
    id: graphicalDebugRect
    anchors.fill: parent
    color: "#33ff0000"
  }
}
