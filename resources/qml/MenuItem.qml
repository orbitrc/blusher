import QtQuick 2.12
import QtGraphicalEffects 1.0

import Blusher 0.1 as Blusher

Blusher.View {
  id: root

  property Blusher.MenuItem menuItem

  readonly property int separatorHeight: 4
  readonly property string separatorColor: "#d8d8d8"

  property bool submenuOpened: false

  height: (!root.menuItem.separator) ? 24 : 12

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

        radius: 4
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
      radius: 4
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

    anchors.verticalCenter: parent.verticalCenter
    anchors.left: parent.left
    anchors.leftMargin: 8

    text: menuItem.title
    font.pixelSize: 14
  }
  Text {
    id: submenuIcon

    visible: root.menuItem.submenu

    anchors.right: parent.right

    text: '>'
    font.bold: true
  }
  MouseArea {
    anchors.fill: parent

    hoverEnabled: true

    onPressed: {
      // Ignore separator.
      if (root.menuItem.separator) {
        return;
      }

      // Emit signal.
      root.menuItem.triggered();
    }

    onEntered: {
      // Ignore separator.
      if (root.menuItem.separator) {
        return;
      }

      // Hover state.
      rootRect.state = 'hovered';

      // Submenu open.
      if (root.menuItem.submenu && !root.submenuOpened) {
        let pos = mapToItem(root, root.width, root.height);
        print(pos);
        root.menuItem.submenu.open(pos.x, pos.y);
        root.submenuOpened = true;
      }
    }

    onExited: {
      if (root.submenuOpened) {
        return;
      }

      rootRect.state = '';
    }
  }
}
