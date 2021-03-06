import QtQuick 2.0
import QtQuick.Layouts 1.12

import "../modules"
import Blusher.DesktopEnvironment 0.1

Rectangle {
  id: root

  property string title: ""
  property Image icon
  property string path: ""

  border.width: 0
  color: "#00000000"

  height: 30
  Layout.fillWidth: true

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    onClicked: {
      Pouch.pwd = root.path;
    }

    onEntered: {
      root.color = "cyan";
    }
    onExited: {
      root.color = "#00000000";
    }
  }

  Image {
    source: root.icon.source
    height: 24
    width: 24
    anchors.verticalCenter: parent.verticalCenter
  }

  Text {
    text: root.title

    x: 40
    anchors.verticalCenter: parent.verticalCenter
    font.pixelSize: 14 * DesktopEnvironment.pixelsPerDp
  }
}
