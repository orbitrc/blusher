import QtQuick 2.12

Item {
  id: root

  clip: true

  default property list<Item> childItems

  property bool vertical: true
  property bool horizontal: false

  Component.onCompleted: {
  }

  Item {
    id: contentArea
    children: root.childItems
    width: contentArea.childrenRect.width
    height: contentArea.childrenRect.height
  }

  MouseArea {
    anchors.fill: parent

    onWheel: {
      let newY = contentArea.y + wheel.angleDelta.y;
      if (newY > 0) {
        contentArea.y = 0;
        return;
      }
      if (newY < root.minimumContentY()) {
        contentArea.y = root.minimumContentY();
        return;
      }

      contentArea.y = newY;
    }

    Rectangle {
      id: verticalTrack

      anchors.right: parent.right
      visible: (root.height <= contentArea.height)
      width: 10
      height: root.height
      color: "#55dedede"

      Rectangle {
        id: verticalKnob

        width: 8
        height: root.knobHeight()
        y: -contentArea.y
        color: "cyan"
      }
    }
  }

  function knobHeight() {
    return 80;
  }

  function minimumContentY() {
    return -100;
  }
}
