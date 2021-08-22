import QtQuick 2.12

import Blusher 0.1

View {
  id: root

  clip: true

  default property list<Item> childItems

  property bool vertical: true
  property bool horizontal: false

  //================
  // Constants
  //================
  readonly property double minimumKnobHeight: 30

  Component.onCompleted: {
  }

  View {
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

    Box {
      id: verticalTrack

      x: parent.width - width
      visible: (root.height <= contentArea.height)
      width: 10
      height: root.height
      color: "#55dedede"

      Box {
        id: verticalKnob

        width: 8
        radius: 4
        height: root.knobHeight()
        y: root.verticalKnobY()
        color: "cyan"
      }
    }
  }

  function knobHeight() {
    const height = root.height - 40;
    if (height < root.minimumKnobHeight) {
      return root.minimumKnobHeight;
    }
    return height;
  }

  function verticalKnobY() {
    if (contentArea.y === 0) {
      return 0;
    }
    const y = (-contentArea.y / (contentArea.height - root.height)) * (root.height - knobHeight());
    console.log(y);
    return y;
  }

  function minimumContentY() {
    return root.height - contentArea.height;
  }
}
