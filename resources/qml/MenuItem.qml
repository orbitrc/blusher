import QtQuick 2.12
import QtGraphicalEffects 1.0

import Blusher 0.1 as Blusher

Blusher.View {
  id: root

  property Blusher.MenuItem menuItem

  readonly property int separatorHeight: 4
  readonly property string separatorColor: "#d8d8d8"

  height: (!root.menuItem.separator) ? 20 : 12

  Rectangle {
    id: rootRect
    anchors.fill: parent
    color: "#eaeaea"
    states: [
      State {
        name: 'hovered'
        PropertyChanges {
          target: shadowBlend
          visible: true
        }
      }
    ]
    Item {
      id: innerShadowSource

      anchors.fill: parent

      Rectangle {
        id: hoveredIndicator

        anchors.fill: parent
        anchors.margins: 2

        color: rootRect.color
      }
    }
    InnerShadow {
      id: topLeftShadow

      visible: false
      anchors.fill: innerShadowSource
      horizontalOffset: 2
      verticalOffset: 2
      radius: 4
      samples: 16
      color: "#808080"
      source: innerShadowSource
    }
    InnerShadow {
      id: bottomRightShadow

      visible: false
      anchors.fill: innerShadowSource
      horizontalOffset: -2
      verticalOffset: -2
      radius: 2
      samples: 16
      color: "#ffffff"
      source: innerShadowSource
    }
    Blend {
      id: shadowBlend

      visible: false

      anchors.fill: topLeftShadow
      source: topLeftShadow
      foregroundSource: bottomRightShadow
      mode: "average"
    }

    Rectangle {
      id: separatorBar

      visible: root.menuItem.separator

      anchors.centerIn: parent
      width: parent.width
      height: root.separatorHeight

      color: root.separatorColor
    }
  }
  Text {
    visible: !root.menuItem.separator
    text: menuItem.title
    font.pixelSize: 16
  }
  MouseArea {
    anchors.fill: parent

    hoverEnabled: true

    onEntered: {
      print('entered');
      rootRect.state = 'hovered';
    }

    onExited: {
      print('exited');
      rootRect.state = '';
    }
  }
}
