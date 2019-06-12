import QtQuick 2.12
import QtGraphicalEffects 1.0

Rectangle {
  id: root
  enum ButtonType {
    PushButton
  }

  property string text: ""
  signal clicked(var mouse)
  //==============
  // State
  //==============
  property bool active: false
  property bool hover: false

  width: 150
  height: 34
  color: "transparent"
  border.width: 0
  MouseArea {
    id: mouseArea
    anchors.fill: parent

    onPressed: {
      root.active = true
    }
    onReleased: {
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
        GradientStop { position: 0.0; color: "black" }
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
    text: root.text
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
  }
}
